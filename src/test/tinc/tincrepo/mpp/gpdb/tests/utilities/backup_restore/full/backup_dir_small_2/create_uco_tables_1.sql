-- @gucs gp_create_table_random_default_distribution=off
-- @product_version gpdb: [4.3.0.0- main]

-- Create updatable AO tables
CREATE TABLE uco_table1_1(
          text_col text,
          bigint_col bigint,
          char_vary_col character varying(30),
          numeric_col numeric,
          int_col int4 NOT NULL,
          float_col float4,
          int_array_col int[],
          before_rename_col int4,
          change_datatype_col numeric,
          a_ts_without timestamp without time zone,
          b_ts_with timestamp with time zone,
          date_column date ,
          col_set_default numeric) with(appendonly=true, orientation=column) DISTRIBUTED RANDOMLY;

insert into uco_table1_1 values ('0_zero', 0, '0_zero', 0, 0, 0, '{0}', 0, 0, '2004-10-19 10:23:54', '2004-10-19 10:23:54+02', '1-1-2000',0);
insert into uco_table1_1 values ('1_zero', 1, '1_zero', 1, 1, 1, '{1}', 1, 1, '2005-10-19 10:23:54', '2005-10-19 10:23:54+02', '1-1-2001',1);
insert into uco_table1_1 values ('2_zero', 2, '2_zero', 2, 2, 2, '{2}', 2, 2, '2006-10-19 10:23:54', '2006-10-19 10:23:54+02', '1-1-2002',2);

CREATE TABLE uco_table2_1(
          col_text text,
          col_numeric numeric
          CONSTRAINT tbl_chk_con1 CHECK (col_numeric < 250)
          ) with(appendonly=true, orientation=column) DISTRIBUTED by(col_numeric);

insert into uco_table2_1 values ('0_zero',0);
insert into uco_table2_1 values ('1_one',1);
insert into uco_table2_1 values ('2_two',2);
insert into uco_table2_1 select i||'_'||repeat('text',3),i from generate_series(1,10)i;

--Table in non-public schema

CREATE SCHEMA ucoschema1_1;
CREATE TABLE ucoschema1_1.uco_table3_1(
          stud_id int,
          stud_name varchar(20)
          ) with(appendonly=true, orientation=column) DISTRIBUTED by(stud_id);

insert into ucoschema1_1.uco_table3_1 values ( 1,'ann');
insert into ucoschema1_1.uco_table3_1 values ( 2,'ben');

-- Updatable AO tables
CREATE TABLE uco_table6_1 with(appendonly=true, orientation=column) as select * from uco_table2_1;
Update uco_table6_1 set col_text= 'new_0_zero' where col_numeric=0;

CREATE TABLE ucoschema1_1.uco_table7_1 with(appendonly=true, orientation=column) as select * from uco_table2_1;
Update ucoschema1_1.uco_table7_1 set col_text= 'new_0_zero' where col_numeric=0;

-- Tables with compression
CREATE TABLE uco_compr01_1(
          col_text text,
          col_numeric numeric
          CONSTRAINT tbl_chk_con1 CHECK (col_numeric < 250)
          ) with(appendonly=true, orientation=column, compresstype='zlib', compresslevel=1, blocksize=8192) DISTRIBUTED by(col_numeric);

insert into uco_compr01_1 values ('0_zero',0);
insert into uco_compr01_1 values ('1_one',1);
insert into uco_compr01_1 values ('2_two',2);
