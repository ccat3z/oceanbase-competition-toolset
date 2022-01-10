EXPLAIN BASIC
SELECT MIN( a ) FROM t1 WHERE a = NULL;
SELECT MIN( a ) FROM t1 WHERE a = NULL;

EXPLAIN BASIC
SELECT MIN( a ) FROM t1 WHERE a <> NULL;
SELECT MIN( a ) FROM t1 WHERE a <> NULL;

EXPLAIN BASIC
SELECT MIN( a ) FROM t1 WHERE a > NULL;
SELECT MIN( a ) FROM t1 WHERE a > NULL;

EXPLAIN BASIC
SELECT MIN( a ) FROM t1 WHERE a < NULL;
SELECT MIN( a ) FROM t1 WHERE a < NULL;

if (!$skip_null_safe_test)
{
EXPLAIN BASIC
SELECT MIN( a ) FROM t1 WHERE a <=> NULL;
SELECT MIN( a ) FROM t1 WHERE a <=> NULL;
}

EXPLAIN BASIC
SELECT MIN( a ) FROM t1 WHERE a BETWEEN NULL AND 10;
SELECT MIN( a ) FROM t1 WHERE a BETWEEN NULL AND 10;

EXPLAIN BASIC
SELECT MIN( a ) FROM t1 WHERE a BETWEEN NULL AND NULL;
SELECT MIN( a ) FROM t1 WHERE a BETWEEN NULL AND NULL;

EXPLAIN BASIC
SELECT MIN( a ) FROM t1 WHERE a BETWEEN 10 AND NULL;
SELECT MIN( a ) FROM t1 WHERE a BETWEEN 10 AND NULL;

EXPLAIN BASIC
SELECT MIN( a ) FROM t1 WHERE a = (SELECT a FROM t1 WHERE a < 0);
SELECT MIN( a ) FROM t1 WHERE a = (SELECT a FROM t1 WHERE a < 0);

EXPLAIN BASIC
SELECT MIN( a ) FROM t1 WHERE a IS NULL;
SELECT MIN( a ) FROM t1 WHERE a IS NULL;