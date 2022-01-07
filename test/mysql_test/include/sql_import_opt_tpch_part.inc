--disable_query_log
--disable_result_log

let $import_already = 0;
#### 检查数据完整性
--error 0,1146,942
let $has_tpch = query_get_value(select max(1) as NUM from opt_tpch_part.nation, NUM, 1);
if ($has_tpch == 1)
{
  let $cust_count = query_get_value(select count(*) as NUM from opt_tpch_part.customer, NUM, 1);
  let $line_count = query_get_value(select count(*) as NUM from opt_tpch_part.lineitem, NUM, 1);
  let $nation_count = query_get_value(select count(*) as NUM from opt_tpch_part.nation, NUM, 1);
  let $orders_count = query_get_value(select count(*) as NUM from opt_tpch_part.orders, NUM, 1);
  let $part_count = query_get_value(select count(*) as NUM from opt_tpch_part.part, NUM, 1);
  let $supp_count = query_get_value(select count(*) as NUM from opt_tpch_part.partsupp, NUM, 1);
  let $region_count = query_get_value(select count(*) as NUM from opt_tpch_part.region, NUM, 1);
  let $supplier_count = query_get_value(select count(*) as NUM from opt_tpch_part.supplier, NUM, 1);

  if ($cust_count == 300 && $line_count == 11957 && $nation_count == 25 && $orders_count == 3000
  && $part_count == 400 && $supp_count == 1500 && $region_count == 5 && $supplier_count == 1) {
    let $import_already = 1;
  }
}

#### 如果数据不完整则重新导入
if($import_already == 0)
{
    --source mysql_test/include/sql_import_opt_tpch_part_internal.inc
    --source mysql_test/include/majorfreeze.inc
    --source mysql_test/include/wait_daily_merge.inc
}

--enable_query_log
--enable_result_log
