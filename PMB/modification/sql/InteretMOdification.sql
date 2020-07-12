DELIMITER $$

DROP PROCEDURE IF EXISTS `pawn_pmb`.`test_proc3` $$
CREATE PROCEDURE `pawn_pmb`.`test_proc3`()
begin
DECLARE  dueAmount double;
DECLARE  paidAmount double;
DECLARE  receiptAmount double;
DECLARE  ticketNo  varchar(20);
DECLARE  receiptId  int;

set dueAmount = 250;
set paidAmount = 250;
set ticketNo ='AP2PW10000028';
set receiptAmount = 0.0;

update pawn_pmb.tblduefrom set dueamount = dueAmount, paidamount = paidAmount where ticketid in (select ticketid from pawn_pmb.tblticket where tktno = ticketNo) and duetypeid = 2;
/*update pawn_pmb.tblduefrom set dueamount = dueAmount, paidamount = paidAmount,balamount= paidAmount where ticketid in (select ticketid from pawn_pmb.tblticket where tktno = ticketNo) and duetypeid = 2;*/
update pawn_pmb.tblduereceipt set setamount= paidAmount where ticketid in (select ticketid from pawn_pmb.tblticket where tktno = ticketNo) and duetypeid = 2;

select  sum(setamount) into receiptAmount from pawn_pmb.tblduereceipt where ticketid in (select ticketid from pawn_pmb.tblticket where tktno = ticketNo);
select  rcpid into receiptId from pawn_pmb.tblduereceipt where ticketid in (select ticketid from pawn_pmb.tblticket where tktno = ticketNo) and duetypeid = 2;

update pawn_pmb.tblreceipt set rcpamount = receiptAmount where rcpid = receiptId ;


select * from pawn_pmb.tblduefrom where ticketid in (select ticketid from pawn_pmb.tblticket where tktno = ticketNo) and duetypeid = 2;
select * from pawn_pmb.tblduereceipt where ticketid in (select ticketid from pawn_pmb.tblticket where tktno = ticketNo) and duetypeid = 2;
select * from pawn_pmb.tblreceipt where rcpid = receiptId ; 

END $$

DELIMITER ;
call pawn_pmb.test_proc3();


