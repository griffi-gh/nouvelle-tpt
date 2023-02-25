typedef unsigned __int64  uintptr_t;typedef char* va_list;void __cdecl __va_start(va_list* , ...);typedef unsigned __int64 size_t;typedef __int64 ptrdiff_t;typedef __int64 intptr_t;typedef _Bool __vcrt_bool;typedef unsigned short wchar_t;void __cdecl __security_init_cookie(void);void __cdecl __security_check_cookie(  uintptr_t _StackCookie);void __cdecl __report_gsfailure(  uintptr_t _StackCookie);uintptr_t __security_cookie;typedef _Bool __crt_bool;void __cdecl _invalid_parameter_noinfo(void);void __cdecl _invalid_parameter_noinfo_noreturn(void);
void __cdecl _invoke_watson(	wchar_t const* _Expression,	wchar_t const* _FunctionName,	wchar_t const* _FileName,	unsigned int _LineNo,	uintptr_t _Reserved);typedef int errno_t;
typedef unsigned short wint_t;
typedef unsigned short wctype_t;
typedef long __time32_t;
typedef __int64 __time64_t;typedef struct __crt_locale_data_public
{	unsigned short const* _locale_pctype;	int _locale_mb_cur_max;	unsigned int _locale_lc_codepage;
} __crt_locale_data_public;typedef struct __crt_locale_pointers
{	struct __crt_locale_data*    locinfo;	struct __crt_multibyte_data* mbcinfo;
} __crt_locale_pointers;typedef __crt_locale_pointers* _locale_t;typedef struct _Mbstatet
{ 	unsigned long _Wchar;	unsigned short _Byte, _State;
} _Mbstatet;typedef _Mbstatet mbstate_t;typedef __time64_t time_t;typedef size_t rsize_t;int* __cdecl _errno(void);errno_t __cdecl _set_errno(  int _Value);errno_t __cdecl _get_errno(  int* _Value);unsigned long  __cdecl __threadid(void);uintptr_t __cdecl __threadhandle(void);typedef struct lua_State lua_State;typedef int (*lua_CFunction) (lua_State *L);typedef const char * (*lua_Reader) (lua_State *L, void *ud, size_t *sz);typedef int (*lua_Writer) (lua_State *L, const void* p, size_t sz, void* ud);typedef void * (*lua_Alloc) (void *ud, void *ptr, size_t osize, size_t nsize);typedef double lua_Number;typedef ptrdiff_t lua_Integer;lua_State *(lua_newstate) (lua_Alloc f, void *ud);
void       (lua_close) (lua_State *L);
lua_State *(lua_newthread) (lua_State *L);lua_CFunction (lua_atpanic) (lua_State *L, lua_CFunction panicf);int (lua_gettop) (lua_State *L);
void (lua_settop) (lua_State *L, int idx);
void (lua_pushvalue) (lua_State *L, int idx);
void (lua_remove) (lua_State *L, int idx);
void (lua_insert) (lua_State *L, int idx);
void (lua_replace) (lua_State *L, int idx);
int (lua_checkstack) (lua_State *L, int sz);void (lua_xmove) (lua_State *from, lua_State *to, int n);int (lua_isnumber) (lua_State *L, int idx);
int (lua_isstring) (lua_State *L, int idx);
int (lua_iscfunction) (lua_State *L, int idx);
int (lua_isuserdata) (lua_State *L, int idx);
int (lua_type) (lua_State *L, int idx);
const char *(lua_typename) (lua_State *L, int tp);int (lua_equal) (lua_State *L, int idx1, int idx2);
int (lua_rawequal) (lua_State *L, int idx1, int idx2);
int (lua_lessthan) (lua_State *L, int idx1, int idx2);lua_Number (lua_tonumber) (lua_State *L, int idx);
lua_Integer (lua_tointeger) (lua_State *L, int idx);
int (lua_toboolean) (lua_State *L, int idx);
const char *(lua_tolstring) (lua_State *L, int idx, size_t *len);
size_t (lua_objlen) (lua_State *L, int idx);
lua_CFunction (lua_tocfunction) (lua_State *L, int idx);
void *(lua_touserdata) (lua_State *L, int idx);
lua_State *(lua_tothread) (lua_State *L, int idx);
const void *(lua_topointer) (lua_State *L, int idx);void  (lua_pushnil) (lua_State *L);void  (lua_pushnumber) (lua_State *L, lua_Number n);void  (lua_pushinteger) (lua_State *L, lua_Integer n);void  (lua_pushlstring) (lua_State *L, const char *s, size_t l);void  (lua_pushstring) (lua_State *L, const char *s);const char *(lua_pushvfstring) (lua_State *L, const char *fmt, va_list argp);const char *(lua_pushfstring) (lua_State *L, const char *fmt, ...);void  (lua_pushcclosure) (lua_State *L, lua_CFunction fn, int n);void  (lua_pushboolean) (lua_State *L, int b);void  (lua_pushlightuserdata) (lua_State *L, void *p);int   (lua_pushthread) (lua_State *L);void  (lua_gettable) (lua_State *L, int idx);void  (lua_getfield) (lua_State *L, int idx, const char *k);void  (lua_rawget) (lua_State *L, int idx);void  (lua_rawgeti) (lua_State *L, int idx, int n);void  (lua_createtable) (lua_State *L, int narr, int nrec);void *(lua_newuserdata) (lua_State *L, size_t sz);int   (lua_getmetatable) (lua_State *L, int objindex);void  (lua_getfenv) (lua_State *L, int idx);void  (lua_settable) (lua_State *L, int idx);void  (lua_setfield) (lua_State *L, int idx, const char *k);void  (lua_rawset) (lua_State *L, int idx);void  (lua_rawseti) (lua_State *L, int idx, int n);int   (lua_setmetatable) (lua_State *L, int objindex);int   (lua_setfenv) (lua_State *L, int idx);void  (lua_call) (lua_State *L, int nargs, int nresults);int   (lua_pcall) (lua_State *L, int nargs, int nresults, int errfunc);int   (lua_cpcall) (lua_State *L, lua_CFunction func, void *ud);int   (lua_load) (lua_State *L, lua_Reader reader, void *dt, const char *chunkname);int (lua_dump) (lua_State *L, lua_Writer writer, void *data);int  (lua_yield) (lua_State *L, int nresults);int  (lua_resume) (lua_State *L, int narg);int  (lua_status) (lua_State *L);int (lua_gc) (lua_State *L, int what, int data);int   (lua_error) (lua_State *L);int   (lua_next) (lua_State *L, int idx);void  (lua_concat) (lua_State *L, int n);lua_Alloc (lua_getallocf) (lua_State *L, void **ud);void lua_setallocf (lua_State *L, lua_Alloc f, void *ud);void lua_setlevel	(lua_State *from, lua_State *to);typedef struct lua_Debug lua_Debug;  typedef void (*lua_Hook) (lua_State *L, lua_Debug *ar);int lua_getstack (lua_State *L, int level, lua_Debug *ar);int lua_getinfo (lua_State *L, const char *what, lua_Debug *ar);const char *lua_getlocal (lua_State *L, const lua_Debug *ar, int n);const char *lua_setlocal (lua_State *L, const lua_Debug *ar, int n);const char *lua_getupvalue (lua_State *L, int funcindex, int n);const char *lua_setupvalue (lua_State *L, int funcindex, int n);int lua_sethook (lua_State *L, lua_Hook func, int mask, int count);lua_Hook lua_gethook (lua_State *L);int lua_gethookmask (lua_State *L);int lua_gethookcount (lua_State *L);void *lua_upvalueid (lua_State *L, int idx, int n);void lua_upvaluejoin (lua_State *L, int idx1, int n1, int idx2, int n2);int lua_loadx (lua_State *L, lua_Reader reader, void *dt,const char *chunkname, const char *mode);const lua_Number *lua_version (lua_State *L);void lua_copy (lua_State *L, int fromidx, int toidx);lua_Number lua_tonumberx (lua_State *L, int idx, int *isnum);lua_Integer lua_tointegerx (lua_State *L, int idx, int *isnum);int lua_isyieldable (lua_State *L);struct lua_Debug {	int event;	const char *name;		const char *namewhat;		const char *what;		const char *source;		int currentline;		int nups;			int linedefined;		int lastlinedefined;		char short_src[60]; 	int i_ci;  
};enum {	LUAJIT_MODE_ENGINE,			LUAJIT_MODE_DEBUG,			LUAJIT_MODE_FUNC,			LUAJIT_MODE_ALLFUNC,			LUAJIT_MODE_ALLSUBFUNC,		LUAJIT_MODE_TRACE,			LUAJIT_MODE_WRAPCFUNC = 0x10,		LUAJIT_MODE_MAX
};int luaJIT_setmode(lua_State *L, int idx, int mode);
typedef void (*luaJIT_profile_callback)(void *data, lua_State *L, int samples, int vmstate);void luaJIT_profile_start(lua_State *L, const char *mode, luaJIT_profile_callback cb, void *data);void luaJIT_profile_stop(lua_State *L);const char *luaJIT_profile_dumpstack(lua_State *L, const char *fmt, int depth, size_t *len);void luaJIT_version_2_1_0_beta3(void);  
