select c.compname,d.leavesqty,d.bookqty,d.unitprice,(d.leavesqty*d.bookqty*d.unitprice) as price from tblorder o
inner join tblorderdetails d on o.orderid = d.orderid
inner join tblusercompany c on o.comid= c.comid
where o.orddate >= '01-01-2011' and o.orddate <= '08-16-2011' and o.prdid = 1


