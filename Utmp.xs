/* @(#) $Id: Utmp.xs,v 1.3 1998/07/24 15:48:45 mxp Exp $ */

#ifdef __cplusplus
extern "C" {
#endif
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#ifdef __cplusplus
}
#endif

#include <utmp.h>

SV *utent2perl(struct utmp *entry)
{
   HV *perl_hash;
   HV *exit_hash;
   
   perl_hash = newHV();
   exit_hash = newHV();

   hv_store(perl_hash, "ut_user", 7, newSVpv(entry->ut_user,  8), 0);
   hv_store(perl_hash, "ut_id",   5, newSVpv(entry->ut_id,    4), 0);
   hv_store(perl_hash, "ut_line", 7, newSVpv(entry->ut_line, 12), 0);
   hv_store(perl_hash, "ut_pid",  6, newSViv(entry->ut_pid),  0);

   switch(entry->ut_type)
   {
      case BOOT_TIME:
	 hv_store(perl_hash, "ut_type", 7, newSVpv("BOOT_TIME", 0), 0);
	 break;
      case DEAD_PROCESS:
	 hv_store(perl_hash, "ut_type", 7, newSVpv("DEAD_PROCESS", 0), 0);
	 break;
      case EMPTY:
	 hv_store(perl_hash, "ut_type", 7, newSVpv("EMPTY", 0), 0);
	 break;
      case INIT_PROCESS:
	 hv_store(perl_hash, "ut_type", 7, newSVpv("INIT_PROCESS", 0), 0);
	 break;
      case LOGIN_PROCESS:
	 hv_store(perl_hash, "ut_type", 7, newSVpv("LOGIN_PROCESS", 0), 0);
	 break;
      case NEW_TIME:
	 hv_store(perl_hash, "ut_type", 7, newSVpv("NEW_TIME", 0), 0);
	 break;
      case OLD_TIME:
    	 hv_store(perl_hash, "ut_type", 7, newSVpv("OLD_TIME", 0), 0);
	 break;
      case RUN_LVL:
	 hv_store(perl_hash, "ut_type", 7, newSVpv("RUN_LVL", 0), 0);
	 break;
      case USER_PROCESS:
	 hv_store(perl_hash, "ut_type", 7, newSVpv("USER_PROCESS", 0), 0);
	 break;
   }
      
   hv_store(exit_hash, "e_termination", 13,
	    newSViv(entry->ut_exit.e_termination), 0);
   hv_store(exit_hash, "e_exit", 6,
	    newSViv(entry->ut_exit.e_exit), 0);
   hv_store(perl_hash, "ut_exit", 7, newRV_noinc((SV *) exit_hash), 0);

   hv_store(perl_hash, "ut_time", 7, newSViv(entry->ut_time), 0);
   hv_store(perl_hash, "ut_host", 7, newSVpv(entry->ut_host, 16), 0);
   hv_store(perl_hash, "ut_addr", 7, newSVpv((char *) &entry->ut_addr, 0), 0);

   return newRV_noinc((SV *) perl_hash);
}

MODULE = User::Utmp		PACKAGE = User::Utmp		

void
getut()
   PREINIT:
      struct utmp *entry;
   PPCODE:
      setutent();
      while((entry = getutent()))
      {
	 XPUSHs(sv_2mortal(utent2perl(entry)));
      }
      endutent();

void
utmpname(utmp_file)
   char *utmp_file
   CODE:
      utmpname(utmp_file);
