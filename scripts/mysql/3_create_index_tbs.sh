#!/bin/bash

#change this for your database configuration
USER_NAME='tpce'
DB_NAME='tpce'

QUERY_TEXTS=(
'CREATE INDEX i_c_tax_id ON customer (c_tax_id);'
'CREATE INDEX i_co_name ON company (co_name);'
'CREATE INDEX i_th_t_id_dts ON trade_history (th_t_id, th_dts);'
'CREATE INDEX i_in_name ON industry (in_name);'
'CREATE INDEX i_sc_name ON sector (sc_name);'
'CREATE INDEX i_t_ca_id_dts ON trade (t_ca_id, t_dts);'
'CREATE INDEX i_t_s_symb_dts ON trade (t_s_symb, t_dts);'
'CREATE INDEX i_h_ca_id_s_symb_dts ON holding (h_ca_id, h_s_symb, h_dts);'
)

execute_query(){
echo "cur query : ${1}"

mysql -u${USER_NAME} ${USER_NAME} <<EOF 
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;

${1}

SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
EOF

echo "Done load table for : ${1}"
}

cleanup_tables(){

mysql -u${USER_NAME} ${DB_NAME} <<EOF 
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;

--delete all indexes
DROP INDEX i_c_tax_id ON customer ;
DROP INDEX i_co_name ON company ;
DROP INDEX i_th_t_id_dts ON trade_history ;
DROP INDEX i_in_name ON industry ;
DROP INDEX i_sc_name ON sector ;
DROP INDEX i_t_ca_id_dts ON trade ;
DROP INDEX i_t_s_symb_dts ON trade ;
DROP INDEX i_h_ca_id_s_symb_dts ON holding ;

SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
EOF

}


#main

## Truncate table first 
## if you don't want to remove any index, then comment out following line
cleanup_tables

for Q_TEXT in "${QUERY_TEXTS[@]}"
do
#	echo "current query text is : ${Q_TEXT}"
	execute_query "${Q_TEXT}" &
done

wait

echo "Done Create indexes for all tables "

