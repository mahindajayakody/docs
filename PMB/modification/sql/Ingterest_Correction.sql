DELIMITER $$

DROP PROCEDURE IF EXISTS `pawn_pmb`.`Ingterest_Correction` $$
CREATE PROCEDURE `pawn_pmb`.`Ingterest_Correction`()
begin
    declare ticketCount,i,minDays int;
    declare pawnAdvance,intRate double;
    set ticketCount = 0,i = 0,pawnAdvance = 0.0,minDays = 30,intRate = 15/36500;
    
    select count(*) into ticketCount from pawn_pmb.tblticket;
    while i <= ticketCount do
        select pawnadv into pawnAdvance from pawn_pmb.tblticket where ticketid = i and stsid = 1;
        set mintInt = pawnAdvance * intRate * minDays;
        set i = i + 1;
    end while ;

END $$

DELIMITER ;
call pawn_pmb.Ingterest_Correction();