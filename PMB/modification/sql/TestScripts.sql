select * from pawn_pmb.tblsystemdate where branchid = 4;
select * from pawn_pmb.tblbranch

update pawn_pmb.tblsystemdate set curdate = '2011-03-30' where branchid = 3;
select * from pawn_pmb.tblduefrom where ticketid = 161;

select * from pawn_pmb.tblreceipt where rcpno = 'AP211R000008'
update pawn_pmb.tblreceipt set rcpdate = '2011-01-25' where rcpno = 'AP211R000013'

update pawn_pmb.tblduefrom set paidamount = 250 where ticketid = 161;