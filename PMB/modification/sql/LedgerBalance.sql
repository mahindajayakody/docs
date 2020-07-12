select b.code as 'branch' ,d.code as 'DueType',sum(cramount) as 'CR',sum(dramount) as 'DR' from pawn_pmb.tblledger l
inner join pawn_pmb.tblbranch b on b.branchid = l.branchid
inner join pawn_pmb.tblduetype d on l.duetypeid = d.duetypeid
where l.date >= '2011-08-01'  and l.date <= '2011-09-30' group by l.branchid,l.duetypeid