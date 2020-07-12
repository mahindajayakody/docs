select t.ticketid,tktno,mindays,t.intslabid,i.rate,d.dueamount,date(t.condate),t.pawnadv from pawn_pmb.tblticket t
inner join pawn_pmb.tblinterestslabs i on i.intslabid = t.intslabid 
inner join pawn_pmb.tblduefrom d on t.ticketid = d.ticketid and d.duetypeid = 2 where mindays > 30 and stsid = 1