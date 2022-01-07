CREATE TABLE nation  ( N_NATIONKEY  INTEGER NOT NULL,
  N_NAME       CHAR(25) NOT NULL,
  N_REGIONKEY  INTEGER NOT NULL,
  N_COMMENT    VARCHAR(152));

CREATE TABLE region  ( R_REGIONKEY  INTEGER NOT NULL,
  R_NAME       CHAR(25) NOT NULL,
  R_COMMENT    VARCHAR(152));

CREATE TABLE `supplier` (
  `s_suppkey` bigint(20) NOT NULL,
  `s_name` char(25) DEFAULT NULL,
  `s_address` varchar(40) DEFAULT NULL,
  `s_nationkey` bigint(20) DEFAULT NULL,
  `s_phone` char(15) DEFAULT NULL,
  `s_acctbal` bigint(20) DEFAULT NULL,
  `s_comment` varchar(101) DEFAULT NULL,
  PRIMARY KEY (`s_suppkey`)
);

CREATE TABLE `part` (
`p_partkey` bigint(20) NOT NULL,
`p_name` varchar(55) DEFAULT NULL,
`p_mfgr` char(25) DEFAULT NULL,
`p_brand` char(10) DEFAULT NULL,
`p_type` varchar(25) DEFAULT NULL,
`p_size` bigint(20) DEFAULT NULL,
`p_container` char(10) DEFAULT NULL,
`p_retailprice` decimal(10,2) DEFAULT NULL,
`p_comment` varchar(23) DEFAULT NULL,
PRIMARY KEY (`p_partkey`)
) DEFAULT CHARSET = utf8mb4 COMPRESSION = 'zstd_1.0' REPLICA_NUM = 1 BLOCK_SIZE = 16384 USE_BLOOM_FILTER = FALSE TABLET_SIZE = 134217728 PCTFREE = 10
partition by hash(p_partkey) partitions 3;

CREATE TABLE `orders` (
  `o_orderkey` bigint(20) NOT NULL,
  `o_custkey` bigint(20) NOT NULL,
  `o_orderstatus` char(1) DEFAULT NULL,
  `o_totalprice` decimal(10,2) DEFAULT NULL,
  `o_orderdate` date NOT NULL,
  `o_orderpriority` char(15) DEFAULT NULL,
  `o_clerk` char(15) DEFAULT NULL,
  `o_shippriority` bigint(20) DEFAULT NULL,
  `o_comment` varchar(79) DEFAULT NULL,
  PRIMARY KEY (`o_orderkey`, `o_orderdate`, `o_custkey`),
  KEY `o_orderkey` (`o_orderkey`) LOCAL  BLOCK_SIZE 16384
) DEFAULT CHARSET = utf8mb4 COMPRESSION = 'zstd_1.0' REPLICA_NUM = 1 BLOCK_SIZE = 16384 USE_BLOOM_FILTER = FALSE TABLET_SIZE = 134217728 PCTFREE = 10
partition by range columns(o_orderdate) subpartition by hash(o_custkey) subpartitions 4
(partition ord1 values less than ('1992-01-01'),
  partition ord2 values less than ('1992-02-01'),
  partition ord3 values less than ('1992-03-01'),
  partition ord4 values less than (MAXVALUE));

CREATE TABLE `lineitem` (
  `l_orderkey` bigint(20) NOT NULL,
  `l_partkey` bigint(20) NOT NULL,
  `l_suppkey` bigint(20) NOT NULL,
  `l_linenumber` bigint(20) NOT NULL,
  `l_quantity` bigint(20) NOT NULL,
  `l_extendedprice` decimal(10,2) NOT NULL,
  `l_discount` decimal(10,2) NOT NULL,
  `l_tax` decimal(10,2) NOT NULL,
  `l_returnflag` char(1) DEFAULT NULL,
  `l_linestatus` char(1) DEFAULT NULL,
  `l_shipdate` date NOT NULL,
  `l_commitdate` date DEFAULT NULL,
  `l_receiptdate` date DEFAULT NULL,
  `l_shipinstruct` char(25) DEFAULT NULL,
  `l_shipmode` char(10) DEFAULT NULL,
  `l_comment` varchar(44) DEFAULT NULL,
  PRIMARY KEY (`l_orderkey`, `l_linenumber`, `l_shipdate`, `l_partkey`),
  KEY `i_l_orderkey` (`l_orderkey`) LOCAL  BLOCK_SIZE 16384
) DEFAULT CHARSET = utf8mb4 COMPRESSION = 'zstd_1.0' REPLICA_NUM = 1 BLOCK_SIZE = 16384 USE_BLOOM_FILTER = FALSE TABLET_SIZE = 134217728 PCTFREE = 10
partition by range columns(l_shipdate) subpartition by hash(l_partkey) subpartitions 4
(partition item1 values less than ('1992-01-01'),
  partition item2 values less than ('1992-02-01'),
  partition item3 values less than ('1992-03-01'),
  partition item4 values less than ('1992-04-01'),
  partition item84 values less than (MAXVALUE));

