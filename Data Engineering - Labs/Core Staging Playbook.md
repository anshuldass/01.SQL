# Ingesting raw data into staging tables — deep dive

## 1) What a staging area *is* (and what it’s not)

- **Staging = landing zone.** It stores *exactly* what you received from sources (files, APIs, queues, DB extracts) with minimal transformation.

- **Purpose:** replayability, debugging, reproducible ETL, separation of responsibilities (ingest vs transform).

- **Not**: the cleaned, canonical model. Don’t mix staging and business logic.

## 2) Typical staging architecture

- One schema/prefix (e.g., `stg_`) separate from `raw_`, `ods_`, `dim_`, `fact_`.

- Option A: **One staging table per source file / feed** — easy to reason about.

- Option B: **Generic staging table** with `raw_payload` (JSON/text) and `schema_name` — useful when schemas change frequently.

- Option C: Hybrid: both per-source and a central `incoming_files` / `raw_events` table for raw blob storage.

## 3) What to store in a staging row (recommended columns)

Always capture the raw data plus metadata so you can audit and replay:

- `stg_<source>_id` — surrogate id (optional, auto-increment)

- `source_name` — name of source feed

- `source_file` or `source_uri` — file name or URL

- `source_record_id` — row id if present in source (helps idempotency)

- `raw_payload` — original row as text/JSON/CSV chunk (one column can hold raw payload)

- `loaded_at` — ingestion timestamp (UTC)

- `batch_id` — unique identifier for the ingestion job (GUID/timestamp)

- `row_hash` — hash of raw_payload (for duplicate detection / idempotency)

- `is_parsed` — flag whether downstream parsing succeeded

- `parse_error` — short error message if parsing failed

- `original_columns…` — optionally include parsed columns in their raw textual form (one column per source field)

- `file_row_number` — useful for mapping back to original file lines

## 4) Example generic DDL (SQL-neutral)

```sql
-- Platform-neutral example: types are illustrative 
CREATE TABLE stg_incoming ( 
    stg_id BIGINT PRIMARY KEY, -- autoinc / row id 
    source_name VARCHAR(200) NOT NULL, 
    source_file VARCHAR(500), 
    source_record_id VARCHAR(200), -- if source provides an id 
    raw_payload TEXT NOT NULL, -- full raw row / json / csv 
    loaded_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP, 
    batch_id VARCHAR(100), -- job id for the ingest 
    row_hash VARCHAR(128), -- e.g. SHA256 hex 
    is_parsed BOOLEAN DEFAULT FALSE, 
    parse_error VARCHAR(1000), 
    file_row_number INT );
```

> Note: exact types/functions differ by DB (TEXT vs NVARCHAR(MAX) vs VARBINARY). Use the platform’s streaming/bulk type.

## 5) Ingest strategies (high level)

- **Bulk file load** — batch load entire file (CSV, Parquet). Fast, preferred for large volumes.

- **Stream / event ingestion** — push messages into staging table (one-insert-per-event).

- **API-driven pulls** — polling or webhooks write to staging.

- **CDC / change table ingestion** — capture-change events landed into staging.

Implementation details vary (COPY, BULK INSERT, `LOAD DATA`, `bcp`, `COPY` in Postgres/Redshift/Snowflake). Keep logic the same: *write raw payload + metadata*.

## 6) Idempotency & deduplication patterns

Goal: re-running ingestion should not duplicate processed business rows.

Common patterns:

- **File manifest + processed_files table**  
  Maintain `processed_files(file_name, batch_id, processed_at, file_checksum)`. If file checksum already processed, skip.

- **Row hash & uniqueness constraint**  
  Compute hash of `raw_payload` (or subset) and upsert only if hash not present.

- **Source record id + source**  
  If source provides unique ids, enforce uniqueness on `(source_name, source_record_id)`.

- **MERGE / UPSERT semantics**  
  Use idempotent upsert/MERGE when moving rows downstream.

Example pseudocode:

`INSERT INTO stg_incoming (...) SELECT ... FROM external_file WHERE NOT EXISTS (  SELECT 1 FROM processed_files WHERE file_checksum = :checksum );`

## 7) Handling schema drift and unknown columns

- **Loose schema staging:** store raw payload (JSON/text) in one column. Parse later.

- **Wide-table staging:** create many nullable columns matching current version — painful with frequent drift.

- **Schema registry & column mapping:** keep a source schema version and mapping table to parsing logic.

- **Dynamic parsing:** use SQL JSON functions or external parser to extract fields at transform time.

## 8) Minimal parsing on ingest vs full parsing

- **Minimal parsing (recommended):** only parse what’s necessary (e.g., validate file format, compute hash, capture file_row_number). Leave heavy parsing to transformation/ODS layer.

- **When to parse at ingest:** when downstream consumers need quick availability or when raw is too big to store in full.

## 9) Error handling & quarantine

- Bad rows should not stop an entire ingest. Use patterns:
  
  - Capture parse errors per-row (`is_parsed=false`, `parse_error`).
  
  - Push malformed rows into `stg_quarantine` with error reason.
  
  - Send an alert/metric when malformed row rate exceeds threshold.

## 10) Example transformation flow from staging -> cleanse (generic)

1. Load file into `stg_incoming`.

2. Validate counts / checksums.

3. Insert parsed rows into `ods_<source>` (canonical typing) using an idempotent MERGE.

4. Update `stg_incoming.is_parsed = true` and set `parse_error = NULL` for successful rows.

5. If rows fail parsing, mark `parse_error` and optionally send to quarantine.

Generic SQL to move parsed rows (pseudo):

```sql
-- parse raw_payload (platform has different JSON/CSV functions) 
INSERT INTO ods_customers 
(customer_key, name, email, created_at) 
SELECT 
compute_surrogate_key(json_extract(raw_payload, '$.id')), 
json_extract(raw_payload, '$.name'), 
json_extract(raw_payload, '$.email'), try
_cast(json_extract(raw_payload, '$.created_at') AS TIMESTAMP) 
FROM stg_incoming 
WHERE 
source_name = 'customers_api' AND 
is_parsed = FALSE AND 
<parsing succeeds predicate> 
ON CONFLICT (...) DO NOTHING; -- or use MERGE to be idempotent
```

## 11) Validation checks to run after ingest

- Row counts: `count(*)` in file vs `count` in `stg_incoming` for `batch_id`.

- Null rate: `SELECT col, SUM(CASE WHEN col IS NULL THEN 1 ELSE 0 END) FROM stg...`

- Unique keys: check duplicates of `(source_name, source_record_id)` or `row_hash`.

- Checksum: recompute and compare.

- File completeness: expected footer rows, header presence.

## 12) Observability & metadata tracking

- **Batch manifest table** (one row per file/run):
  
  - `batch_id`, `source_name`, `file_name`, `file_checksum`, `file_size`, `ingested_at`, `rows_expected`, `rows_ingested`, `status`, `error_msg`

- **Per-row metadata** stored in staging (see earlier)

- **Metrics dashboard:** failures per batch, parse error ratio, ingestion latency, rows/sec

- **Alerts:** on missing files, processing failures, high parse-error rate.

## 13) Performance & storage considerations

- Storing every raw row increases storage; decide retention policy (e.g., keep raw 90–365 days).

- Compress raw payload columns if platform supports it (e.g., VARBINARY/COMPRESS functions).

- Use partitioning on `loaded_at` or `batch_id` for large staging tables to speed deletion/retention.

- Bulk load instead of many single-row inserts to reduce transaction overhead.

## 14) Security & compliance

- Mask or avoid storing PII in staging if possible. If staging must hold PII, restrict schema access.

- Encrypt sensitive columns at rest if platform requires.

- Keep audit trail for who reprocessed files and when.

## 15) Test scenarios & QA for staging

- Re-run ingest for same file — ensure idempotency.

- Introduce malformed rows — verify quarantine behavior.

- Introduce duplicated rows across two files — verify dedup logic.

- Simulate schema drift (missing/extra column) — verify parser tolerance.

- Validate performance under expected peak load.

## 16) Practical checklist (ready for hands-on)

When you implement staging for a new source, do this:

1. Create source-specific staging table or central raw table.

2. Define `processed_files` manifest table.

3. Decide retention (how long raw rows live).

4. Implement ingest job that:
   
   - computes `batch_id`, `file_checksum`, `row_hash`
   
   - writes raw rows + metadata
   
   - writes `processed_files` row after successful load

5. Implement parse/transform job that:
   
   - reads `stg` rows with `is_parsed = false`
   
   - attempts parsing/validation → `ods` table
   
   - marks `is_parsed` or writes to `stg_quarantine`

6. Add monitoring: counts, error rate alerts, latency metrics.

7. Document schema and the contract with the source system.

## 17) Example: idempotent pattern using MERGE (pseudo-SQL)

```sql
-- Merge into ODS from staging (platform-neutral pseudo) 
MERGE INTO ods_customers AS target USING 
( 
    SELECT 
        source_record_id, 
        json_extract(raw_payload, '$.name') AS name, 
        json_extract(raw_payload, '$.email') AS email, 
        sha256(raw_payload) AS payload_hash 
        FROM stg_incoming 
    WHERE 
        source_name = 'customers_api' AND 
        batch_id = :batch ) AS src 
        ON target.source_name = 'customers_api' AND 
        target.source_record_id = src.source_record_id 
        WHEN MATCHED AND target.payload_hash <> src.payload_hash 
        THEN UPDATE 
            SET name = src.name, 
            email = src.email, 
            payload_hash = src.payload_hash, 
            updated_at = CURRENT_TIMESTAMP 
        WHEN NOT MATCHED 
        THEN INSERT 
            (source_name, 
            source_record_id, 
            name, 
            email, 
            payload_hash, 
            created_at) 
        VALUES 
            ('customers_api', 
            src.source_record_id, 
            src.name, 
            src.email, 
            src.payload_hash, 
            CURRENT_TIMESTAMP);
```

`

> Note: adapt syntax to your platform (`MERGE` for SQL Server/Oracle, `INSERT ... ON CONFLICT` for Postgres, `MERGE` for Snowflake/BigQuery patterns).

## 18) Retention & archival

- Raw rows: archived after N days (e.g., S3 or cold store) or truncated.

- Keep `processed_files` manifest permanently for audit.

- If regulations require, retain raw PII for specified duration in secure storage.

## 19) Real-world pitfalls (war stories)

- Source changes column order without notice — parsing by position breaks. Use header-based parsing or JSON payloads.

- Files get partially uploaded — use temporary file names and atomic rename to indicate completion.

- Clock skew from source systems — always convert to UTC and store timezone information if available.

- Relying on source-supplied IDs that are not globally unique — combine `(source_name, id)`.

## 20) Hands-on tasks you can do next (we’ll map to AdventureWorks later)

- Create a `stg_orders` schema and DDL for incoming CSV orders (with raw_payload + metadata).

- Implement a `processed_files` manifest table and a stored procedure/pseudocode to check file-checksum.

- Write SQL that computes `row_hash` and identifies duplicates in staging.

- Simulate malformed rows and implement quarantine logic.

- Implement a MERGE to upsert parsed rows into `ods_orders` idempotently.

---

That’s the core staging playbook — practical, defensive, and audit-ready.






