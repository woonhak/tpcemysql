#!/bin/bash

USER_NAME='tpce'
DB_NAME='tpce'

QUERY_TEXTS=(
'LOAD DATA LOCAL INFILE "../../flat_out/AccountPermission.txt" INTO TABLE account_permission FIELDS TERMINATED BY "|";'
'LOAD DATA LOCAL INFILE "../../flat_out/Customer.txt" INTO TABLE customer FIELDS TERMINATED BY "|";'
'LOAD DATA LOCAL INFILE "../../flat_out/CustomerAccount.txt" INTO TABLE customer_account FIELDS TERMINATED BY "|";'
'LOAD DATA LOCAL INFILE "../../flat_out/CustomerTaxrate.txt" INTO TABLE customer_taxrate FIELDS TERMINATED BY "|";'
'LOAD DATA LOCAL INFILE "../../flat_out/Holding.txt" INTO TABLE holding FIELDS TERMINATED BY "|";'
'LOAD DATA LOCAL INFILE "../../flat_out/HoldingHistory.txt" INTO TABLE holding_history FIELDS TERMINATED BY "|";'
'LOAD DATA LOCAL INFILE "../../flat_out/HoldingSummary.txt" INTO TABLE holding_summary FIELDS TERMINATED BY "|";'
'LOAD DATA LOCAL INFILE "../../flat_out/WatchItem.txt" INTO TABLE watch_item FIELDS TERMINATED BY "|";'
'LOAD DATA LOCAL INFILE "../../flat_out/WatchList.txt" INTO TABLE watch_list FIELDS TERMINATED BY "|";'
'LOAD DATA LOCAL INFILE "../../flat_out/Broker.txt" INTO TABLE broker FIELDS TERMINATED BY "|";'
'LOAD DATA LOCAL INFILE "../../flat_out/CashTransaction.txt" INTO TABLE cash_transaction FIELDS TERMINATED BY "|";'
'LOAD DATA LOCAL INFILE "../../flat_out/Charge.txt" INTO TABLE charge FIELDS TERMINATED BY "|";'
'LOAD DATA LOCAL INFILE "../../flat_out/CommissionRate.txt" INTO TABLE commission_rate FIELDS TERMINATED BY "|";'
'LOAD DATA LOCAL INFILE "../../flat_out/Settlement.txt" INTO TABLE settlement FIELDS TERMINATED BY "|";'
'LOAD DATA LOCAL INFILE "../../flat_out/Trade.txt" INTO TABLE trade FIELDS TERMINATED BY "|";'
'LOAD DATA LOCAL INFILE "../../flat_out/TradeHistory.txt" INTO TABLE trade_history FIELDS TERMINATED BY "|";'
'LOAD DATA LOCAL INFILE "../../flat_out/TradeType.txt" INTO TABLE trade_type FIELDS TERMINATED BY "|";'
'LOAD DATA LOCAL INFILE "../../flat_out/Company.txt" INTO TABLE company FIELDS TERMINATED BY "|";'
'LOAD DATA LOCAL INFILE "../../flat_out/CompanyCompetitor.txt" INTO TABLE company_competitor FIELDS TERMINATED BY "|";'
'LOAD DATA LOCAL INFILE "../../flat_out/DailyMarket.txt" INTO TABLE daily_market FIELDS TERMINATED BY "|";'
'LOAD DATA LOCAL INFILE "../../flat_out/Exchange.txt" INTO TABLE exchange FIELDS TERMINATED BY "|";'
'LOAD DATA LOCAL INFILE "../../flat_out/Financial.txt" INTO TABLE financial FIELDS TERMINATED BY "|";'
'LOAD DATA LOCAL INFILE "../../flat_out/Industry.txt" INTO TABLE industry FIELDS TERMINATED BY "|";'
'LOAD DATA LOCAL INFILE "../../flat_out/LastTrade.txt" INTO TABLE last_trade FIELDS TERMINATED BY "|";'
'LOAD DATA LOCAL INFILE "../../flat_out/NewsItem.txt" INTO TABLE news_item FIELDS TERMINATED BY "|";'
'LOAD DATA LOCAL INFILE "../../flat_out/NewsXRef.txt" INTO TABLE news_xref FIELDS TERMINATED BY "|";'
'LOAD DATA LOCAL INFILE "../../flat_out/Sector.txt" INTO TABLE sector FIELDS TERMINATED BY "|";'
'LOAD DATA LOCAL INFILE "../../flat_out/Security.txt" INTO TABLE security FIELDS TERMINATED BY "|";'
'LOAD DATA LOCAL INFILE "../../flat_out/Address.txt" INTO TABLE address FIELDS TERMINATED BY "|";'
'LOAD DATA LOCAL INFILE "../../flat_out/StatusType.txt" INTO TABLE status_type FIELDS TERMINATED BY "|";'
'LOAD DATA LOCAL INFILE "../../flat_out/Taxrate.txt" INTO TABLE taxrate FIELDS TERMINATED BY "|";'
'LOAD DATA LOCAL INFILE "../../flat_out/ZipCode.txt" INTO TABLE zip_code FIELDS TERMINATED BY "|";'
)

execute_query(){
echo "cur query : ${1}"

mysql -u${USER_NAME} ${DB_NAME} <<EOF 
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

TRUNCATE account_permission ;
TRUNCATE customer ;
TRUNCATE customer_account ;
TRUNCATE customer_taxrate ;
TRUNCATE holding ;
TRUNCATE holding_history ;
TRUNCATE holding_summary ;
TRUNCATE watch_item ;
TRUNCATE watch_list ;
TRUNCATE broker ;
TRUNCATE cash_transaction ;
TRUNCATE charge ;
TRUNCATE commission_rate ;
TRUNCATE settlement ;
TRUNCATE trade ;
TRUNCATE trade_history ;
TRUNCATE trade_type ;
TRUNCATE company ;
TRUNCATE company_competitor ;
TRUNCATE daily_market ;
TRUNCATE exchange ;
TRUNCATE financial ;
TRUNCATE industry ;
TRUNCATE last_trade ;
TRUNCATE news_item ;
TRUNCATE news_xref ;
TRUNCATE sector ;
TRUNCATE security ;
TRUNCATE address ;
TRUNCATE status_type ;
TRUNCATE taxrate ;
TRUNCATE zip_code ;

SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
EOF

}


#main

## Truncate table first 
cleanup_tables

for Q_TEXT in "${QUERY_TEXTS[@]}"
do
#	echo "current query text is : ${Q_TEXT}"
	execute_query "${Q_TEXT}" &
done

wait

echo "Done Load All tables "

