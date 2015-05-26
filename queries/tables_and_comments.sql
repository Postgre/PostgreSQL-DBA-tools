SELECT DISTINCT ON (c.relname)
       n.nspname as schema,
       c.relname,
       a.rolname as owner,
       0 as col_seq,
       '' as column,
       d.description as comment
--	 c.oid
  FROM pg_class c
  JOIN pg_attribute col ON (col.attrelid = c.oid)
  JOIN pg_description d ON (d.objoid = col.attrelid AND d.objsubid = 0)
  JOIN pg_namespace n ON (n.oid = c.relnamespace)
  JOIN pg_authid a ON ( a.OID = c.relowner )
UNION
SELECT n.nspname as schema,
       c.relname,
       '' as owner,
       col.attnum as col_seq,
       col.attname as column,
       d.description as comment
--	 c.oid
  FROM pg_class c
  JOIN pg_attribute col ON (col.attrelid = c.oid)
  JOIN pg_description d ON (d.objoid = col.attrelid AND d.objsubid = col.attnum)
  JOIN pg_namespace n ON (n.oid = c.relnamespace)
  JOIN pg_authid a ON ( a.OID = c.relowner )
WHERE relname NOT LIKE 'pg_%'
  AND relname NOT LIKE 'information%'
  AND relname NOT LIKE 'sql_%'
  AND relkind = 'r'
  AND d.objsubid >= 0
  AND col.attnum >= 0
ORDER BY 1, 2, 4;

