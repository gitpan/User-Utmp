/* @(#) $Id: Utmp.xs,v 1.14 2000/02/27 13:43:43 mxp Exp $ */

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

#ifdef _XOPEN_UNIX
#define HAS_UTMPX
#endif

#ifdef HAS_UTMPX
#include <utmpx.h>
#ifndef LEN_X_UT_USER
#define LEN_X_UT_USER 24
#endif
#ifndef LEN_X_UT_ID
#define LEN_X_UT_ID 4
#endif
#ifndef LEN_X_UT_LINE
#define LEN_X_UT_LINE 12
#endif
#ifndef LEN_X_UT_HOST
#define LEN_X_UT_HOST 64
#endif
#endif

#ifndef MIN
#define MIN(a, b) (((a)<(b))?(a):(b))
#endif

static int
not_here(s)
char *s;
{
    croak("%s not implemented on this architecture", s);
    return -1;
}

static double
constant(name, arg)
char *name;
int arg;
{
    errno = 0;
    switch (*name) {
    case 'B':
	if (strEQ(name, "BOOT_TIME"))
#ifdef BOOT_TIME
	    return BOOT_TIME;
#else
	    goto not_there;
#endif
	break;
    case 'D':
	if (strEQ(name, "DEAD_PROCESS"))
#ifdef DEAD_PROCESS
	    return DEAD_PROCESS;
#else
	    goto not_there;
#endif
	break;
    case 'E':
	if (strEQ(name, "EMPTY"))
#ifdef EMPTY
	    return EMPTY;
#else
	    goto not_there;
#endif
	break;
    case 'I':
	if (strEQ(name, "INIT_PROCESS"))
#ifdef INIT_PROCESS
	    return INIT_PROCESS;
#else
	    goto not_there;
#endif
	break;
    case 'L':
	if (strEQ(name, "LOGIN_PROCESS"))
#ifdef LOGIN_PROCESS
	    return LOGIN_PROCESS;
#else
	    goto not_there;
#endif
	break;
    case 'N':
	if (strEQ(name, "NEW_TIME"))
#ifdef NEW_TIME
	    return NEW_TIME;
#else
	    goto not_there;
#endif
	break;
    case 'O':
	if (strEQ(name, "OLD_TIME"))
#ifdef OLD_TIME
	    return OLD_TIME;
#else
	    goto not_there;
#endif
	break;
    case 'R':
	if (strEQ(name, "RUN_LVL"))
#ifdef RUN_LVL
	    return RUN_LVL;
#else
	    goto not_there;
#endif
	break;
    case 'U':
	if (strEQ(name, "USER_PROCESS"))
#ifdef USER_PROCESS
	    return USER_PROCESS;
#else
	    goto not_there;
#endif
	break;
    }
    errno = EINVAL;
    return 0;

not_there:
    errno = ENOENT;
    return 0;
}


SV *utent2perl(struct utmp *entry)
{
   HV *perl_hash;
   HV *exit_hash;
   
   perl_hash = newHV();
   exit_hash = newHV();

   hv_store(perl_hash, "ut_user", 7,
	    newSVpv(entry->ut_user, MIN(8, strlen(entry->ut_user))), 0);
   hv_store(perl_hash, "ut_id",   5,
	    newSVpv(entry->ut_id, MIN(4, strlen(entry->ut_id))), 0);
   hv_store(perl_hash, "ut_line", 7,
	    newSVpv(entry->ut_line, MIN(12, strlen(entry->ut_line))), 0);
   hv_store(perl_hash, "ut_pid",  6, newSViv(entry->ut_pid),  0);
   hv_store(perl_hash, "ut_type", 7, newSViv(entry->ut_type), 0);
   hv_store(exit_hash, "e_termination", 13,
	    newSViv(entry->ut_exit.e_termination), 0);
   hv_store(exit_hash, "e_exit", 6,  newSViv(entry->ut_exit.e_exit), 0);
   hv_store(perl_hash, "ut_exit", 7, newRV_noinc((SV *) exit_hash), 0);

   hv_store(perl_hash, "ut_time", 7, newSViv(entry->ut_time), 0);

#ifdef HAS_UT_HOST
   hv_store(perl_hash, "ut_host", 7,
	    newSVpv(entry->ut_host, MIN(16, strlen(entry->ut_host))), 0);
#endif

#ifdef HAS_UT_ADDR
   hv_store(perl_hash, "ut_addr", 7, newSVpv((char *) &entry->ut_addr, 0), 0);
#endif

   return newRV_noinc((SV *) perl_hash);
}

#ifdef HAS_UTMPX
SV *utxent2perl(struct utmpx *entry)
{
   HV *perl_hash;
   HV *exit_hash;
   HV *time_hash;

   perl_hash = newHV();
   exit_hash = newHV();
   time_hash = newHV();

   hv_store(perl_hash, "ut_user", 7,
	    newSVpv(entry->ut_user, MIN(LEN_X_UT_USER,
					strlen(entry->ut_user))), 0);
   hv_store(perl_hash, "ut_id",   5,
	    newSVpv(entry->ut_id, MIN(LEN_X_UT_ID, strlen(entry->ut_id))), 0);
   hv_store(perl_hash, "ut_line", 7,
	    newSVpv(entry->ut_line, MIN(LEN_X_UT_LINE,
					strlen(entry->ut_line))), 0);
   hv_store(perl_hash, "ut_pid",  6, newSViv(entry->ut_pid), 0);
   hv_store(perl_hash, "ut_type", 7, newSViv(entry->ut_type), 0);
#ifdef HAS_X_UT_EXIT
   hv_store(exit_hash, "e_termination", 13,
	    newSViv(entry->ut_exit.e_termination), 0);
   hv_store(exit_hash, "e_exit", 6,  newSViv(entry->ut_exit.e_exit), 0);
#endif
#ifdef HAS_X_UT_EXIT_
   hv_store(exit_hash, "e_termination", 13,
	    newSViv(entry->ut_exit.__e_termination), 0);
   hv_store(exit_hash, "e_exit", 6,  newSViv(entry->ut_exit.__e_exit), 0);
#endif
   hv_store(perl_hash, "ut_exit", 7, newRV_noinc((SV *) exit_hash), 0);

   hv_store(time_hash, "tv_sec",  6, newSViv(entry->ut_tv.tv_sec), 0);
   hv_store(time_hash, "tv_usec", 7, newSViv(entry->ut_tv.tv_sec), 0);
   hv_store(perl_hash, "ut_time", 7, newRV_noinc((SV *) time_hash), 0);
#ifdef HAS_X_UT_HOST
#ifdef HAS_X_UT_SYSLEN
   hv_store(perl_hash, "ut_host", 7, newSVpv(entry->ut_host,
					     entry->ut_syslen + 1), 0);
#else
   hv_store(perl_hash, "ut_host", 7,
	    newSVpv(entry->ut_host, MIN(LEN_X_UT_HOST,
					strlen(entry->ut_host))), 0);
#endif
#endif
#ifdef HAS_X_UT_ADDR
   hv_store(perl_hash, "ut_addr", 7, newSViv(entry->ut_addr), 0);
#endif
   return newRV_noinc((SV *) perl_hash);
}
#endif

void perl2utent(HV *entry, struct utmp *utent)
{
   HE    *hashentry;
   char  *key;
   SV    *val;
   I32    len;
   STRLEN strlen;

   hv_iterinit(entry);
   
   while((hashentry = hv_iternext(entry)))
   {
      key = hv_iterkey(hashentry, &len);
      val = hv_iterval(entry, hashentry);
      
      if(strEQ(key, "ut_user"))
      {
	 char* c_val;
	    
	 c_val = SvPV(val, strlen);
	 strncpy(utent->ut_user, c_val, sizeof(utent->ut_user));
      }
      else if(strEQ(key, "ut_id"))
      {
	 char* c_val;

	 c_val = SvPV(val, strlen);
	 strncpy(utent->ut_id, c_val, sizeof(utent->ut_id));
      }
      else if(strEQ(key, "ut_line"))
      {
	 char* c_val;

	 c_val = SvPV(val, strlen);
	 strncpy(utent->ut_line, c_val, sizeof(utent->ut_line));
      }
      else if(strEQ(key, "ut_pid"))
      {
	 utent->ut_pid = (pid_t) SvIV(val);
      }
      else if(strEQ(key, "ut_type"))
      {
	 utent->ut_type = (short) SvIV(val);
      }
      else if(strEQ(key, "ut_exit"))
      {
	 HE *he;
	 char *localkey;
	 SV *localval;

	 hv_iterinit((HV *) SvRV(val));
	 while((he = hv_iternext((HV *) SvRV(val))))
	 {
	    localkey = hv_iterkey(he, &len);
	    localval = hv_iterval((HV *) SvRV(val), he);

	    if(strEQ(key, "e_termination"))
	    {
	       utent->ut_exit.e_termination = (short) SvIV(localval);
	    }
	    else if(strEQ(key, "e_exit"))
	    {
	       utent->ut_exit.e_exit = (short) SvIV(localval);
	    }
	 }
      }
      else if(strEQ(key, "ut_time"))
      {
	 utent->ut_time = (time_t) SvIV(val);
      }
#ifdef HAS_UT_HOST
      if(strEQ(key, "ut_host"))
      {
	 char* c_val;
	    
	 c_val = SvPV(val, strlen);
	 strncpy(utent->ut_host, c_val, sizeof(utent->ut_host));
      }
#endif
#ifdef HAS_UT_ADDR
      else if(strEQ(key, "ut_addr"))
      {
	 memcpy(&utent->ut_addr, SvPV(val, strlen),
		MIN(sizeof(utent->ut_addr), strlen));
      }
#endif
   }
}

MODULE = User::Utmp		PACKAGE = User::Utmp		

PROTOTYPES: ENABLE

double
constant(name,arg)
	char *		name
	int		arg

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

#ifdef HAS_UTMPX
void
getutx()
   PREINIT:
      struct utmpx *entry;
   PPCODE:
      setutxent();
      while((entry = getutxent()))
      {
	 XPUSHs(sv_2mortal(utxent2perl(entry)));
      }
      endutxent();

#endif

void
putut(perl_hash)
   SV *perl_hash
   PREINIT:
      struct utmp entry;
   CODE:
      setutent();
      perl2utent((HV *) SvRV(perl_hash), &entry);
      pututline(&entry);
      endutent();

void
utmpname(utmp_file)
   char *utmp_file
   CODE:
#ifdef HAS_UTMPXNAME
      if (strcmp(utmp_file + (strlen(utmp_file) - 1), "x") == 0)
      {
	 utmpxname(utmp_file);
	 *(utmp_file + (strlen(utmp_file) - 1)) = '\0';
      }
#endif
      utmpname(utmp_file);
