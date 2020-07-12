update pawn.tblofficer set isactive = 1

select * from pawn_pmb.tblsystemprogram

insert into pawn_pmb.tblsystemprogram (prgid,prdcode,parentid,nodename,urlpath,access)
values(21,'PW',0,'Fund Management','',1)

update pawn_pmb.tblsystemprogram set prgid = 5500,parentid = 21 where prgid = 4004
update pawn_pmb.tblsystemprogram set prgid = 5600,parentid = 21 where prgid = 1008


select * from pawn_pmb.tblprgaccess

update pawn_pmb.tblprgaccess set prgid = 5500 where prgid = 4004
update pawn_pmb.tblprgaccess set prgid = 5600 where prgid = 1008