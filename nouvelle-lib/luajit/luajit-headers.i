//luajit.h
typedef __builtin_va_list va_list;
typedef __builtin_va_list __gnuc_va_list;
typedef long int ptrdiff_t;
typedef long unsigned int size_t;
typedef int wchar_t;
typedef struct lua_State lua_State;
typedef int (*lua_CFunction) (lua_State *L);
typedef const char * (*lua_Reader) (lua_State *L, void *ud, size_t *sz);
typedef int (*lua_Writer) (lua_State *L, const void* p, size_t sz, void* ud);
typedef void * (*lua_Alloc) (void *ud, void *ptr, size_t osize, size_t nsize);
typedef double lua_Number;
typedef ptrdiff_t lua_Integer;
lua_State *(lua_newstate) (lua_Alloc f, void *ud);
void (lua_close) (lua_State *L);
lua_State *(lua_newthread) (lua_State *L);
lua_CFunction (lua_atpanic) (lua_State *L, lua_CFunction panicf);
int (lua_gettop) (lua_State *L);
void (lua_settop) (lua_State *L, int idx);
void (lua_pushvalue) (lua_State *L, int idx);
void (lua_remove) (lua_State *L, int idx);
void (lua_insert) (lua_State *L, int idx);
void (lua_replace) (lua_State *L, int idx);
int (lua_checkstack) (lua_State *L, int sz);
void (lua_xmove) (lua_State *from, lua_State *to, int n);
int (lua_isnumber) (lua_State *L, int idx);
int (lua_isstring) (lua_State *L, int idx);
int (lua_iscfunction) (lua_State *L, int idx);
int (lua_isuserdata) (lua_State *L, int idx);
int (lua_type) (lua_State *L, int idx);
const char *(lua_typename) (lua_State *L, int tp);
int (lua_equal) (lua_State *L, int idx1, int idx2);
int (lua_rawequal) (lua_State *L, int idx1, int idx2);
int (lua_lessthan) (lua_State *L, int idx1, int idx2);
lua_Number (lua_tonumber) (lua_State *L, int idx);
lua_Integer (lua_tointeger) (lua_State *L, int idx);
int (lua_toboolean) (lua_State *L, int idx);
const char *(lua_tolstring) (lua_State *L, int idx, size_t *len);
size_t (lua_objlen) (lua_State *L, int idx);
lua_CFunction (lua_tocfunction) (lua_State *L, int idx);
void *(lua_touserdata) (lua_State *L, int idx);
lua_State *(lua_tothread) (lua_State *L, int idx);
const void *(lua_topointer) (lua_State *L, int idx);
void (lua_pushnil) (lua_State *L);
void (lua_pushnumber) (lua_State *L, lua_Number n);
void (lua_pushinteger) (lua_State *L, lua_Integer n);
void (lua_pushlstring) (lua_State *L, const char *s, size_t l);
void (lua_pushstring) (lua_State *L, const char *s);
const char *(lua_pushvfstring) (lua_State *L, const char *fmt, va_list argp);
const char *(lua_pushfstring) (lua_State *L, const char *fmt, ...);
void (lua_pushcclosure) (lua_State *L, lua_CFunction fn, int n);
void (lua_pushboolean) (lua_State *L, int b);
void (lua_pushlightuserdata) (lua_State *L, void *p);
int (lua_pushthread) (lua_State *L);
void (lua_gettable) (lua_State *L, int idx);
void (lua_getfield) (lua_State *L, int idx, const char *k);
void (lua_rawget) (lua_State *L, int idx);
void (lua_rawgeti) (lua_State *L, int idx, int n);
void (lua_createtable) (lua_State *L, int narr, int nrec);
void *(lua_newuserdata) (lua_State *L, size_t sz);
int (lua_getmetatable) (lua_State *L, int objindex);
void (lua_getfenv) (lua_State *L, int idx);
void (lua_settable) (lua_State *L, int idx);
void (lua_setfield) (lua_State *L, int idx, const char *k);
void (lua_rawset) (lua_State *L, int idx);
void (lua_rawseti) (lua_State *L, int idx, int n);
int (lua_setmetatable) (lua_State *L, int objindex);
int (lua_setfenv) (lua_State *L, int idx);
void (lua_call) (lua_State *L, int nargs, int nresults);
int (lua_pcall) (lua_State *L, int nargs, int nresults, int errfunc);
int (lua_cpcall) (lua_State *L, lua_CFunction func, void *ud);
int (lua_load) (lua_State *L, lua_Reader reader, void *dt, const char *chunkname);
int (lua_dump) (lua_State *L, lua_Writer writer, void *data);
int (lua_yield) (lua_State *L, int nresults);
int (lua_resume) (lua_State *L, int narg);
int (lua_status) (lua_State *L);
int (lua_gc) (lua_State *L, int what, int data);
int (lua_error) (lua_State *L);
int (lua_next) (lua_State *L, int idx);
void (lua_concat) (lua_State *L, int n);
lua_Alloc (lua_getallocf) (lua_State *L, void **ud);
void lua_setallocf (lua_State *L, lua_Alloc f, void *ud);
void lua_setlevel (lua_State *from, lua_State *to);
typedef struct lua_Debug lua_Debug;
typedef void (*lua_Hook) (lua_State *L, lua_Debug *ar);
int lua_getstack (lua_State *L, int level, lua_Debug *ar);
int lua_getinfo (lua_State *L, const char *what, lua_Debug *ar);
const char *lua_getlocal (lua_State *L, const lua_Debug *ar, int n);
const char *lua_setlocal (lua_State *L, const lua_Debug *ar, int n);
const char *lua_getupvalue (lua_State *L, int funcindex, int n);
const char *lua_setupvalue (lua_State *L, int funcindex, int n);
int lua_sethook (lua_State *L, lua_Hook func, int mask, int count);
lua_Hook lua_gethook (lua_State *L);
int lua_gethookmask (lua_State *L);
int lua_gethookcount (lua_State *L);
void *lua_upvalueid (lua_State *L, int idx, int n);
void lua_upvaluejoin (lua_State *L, int idx1, int n1, int idx2, int n2);
int lua_loadx (lua_State *L, lua_Reader reader, void *dt, const char *chunkname, const char *mode);
const lua_Number *lua_version (lua_State *L);
void lua_copy (lua_State *L, int fromidx, int toidx);
lua_Number lua_tonumberx (lua_State *L, int idx, int *isnum);
lua_Integer lua_tointegerx (lua_State *L, int idx, int *isnum);
int lua_isyieldable (lua_State *L);
struct lua_Debug {
  int event;
  const char *name;
  const char *namewhat;
  const char *what;
  const char *source;
  int currentline;
  int nups;
  int linedefined;
  int lastlinedefined;
  char short_src[60];
  int i_ci;
};
enum {
  LUAJIT_MODE_ENGINE,
  LUAJIT_MODE_DEBUG,
  LUAJIT_MODE_FUNC,
  LUAJIT_MODE_ALLFUNC,
  LUAJIT_MODE_ALLSUBFUNC,
  LUAJIT_MODE_TRACE,
  LUAJIT_MODE_WRAPCFUNC = 0x10,
  LUAJIT_MODE_MAX
};
int luaJIT_setmode(lua_State *L, int idx, int mode);
typedef void (*luaJIT_profile_callback)(void *data, lua_State *L, int samples, int vmstate);
void luaJIT_profile_start(lua_State *L, const char *mode, luaJIT_profile_callback cb, void *data);
void luaJIT_profile_stop(lua_State *L);
const char *luaJIT_profile_dumpstack(lua_State *L, const char *fmt, int depth, size_t *len);
void luaJIT_version_2_1_0_beta3(void);

//lualib.h

typedef __builtin_va_list va_list;
typedef __builtin_va_list __gnuc_va_list;
typedef long int ptrdiff_t;
typedef long unsigned int size_t;
typedef int wchar_t;
typedef struct lua_State lua_State;
typedef int (*lua_CFunction) (lua_State *L);
typedef const char * (*lua_Reader) (lua_State *L, void *ud, size_t *sz);
typedef int (*lua_Writer) (lua_State *L, const void* p, size_t sz, void* ud);
typedef void * (*lua_Alloc) (void *ud, void *ptr, size_t osize, size_t nsize);
typedef double lua_Number;
typedef ptrdiff_t lua_Integer;
lua_State *(lua_newstate) (lua_Alloc f, void *ud);
void (lua_close) (lua_State *L);
lua_State *(lua_newthread) (lua_State *L);
lua_CFunction (lua_atpanic) (lua_State *L, lua_CFunction panicf);
int (lua_gettop) (lua_State *L);
void (lua_settop) (lua_State *L, int idx);
void (lua_pushvalue) (lua_State *L, int idx);
void (lua_remove) (lua_State *L, int idx);
void (lua_insert) (lua_State *L, int idx);
void (lua_replace) (lua_State *L, int idx);
int (lua_checkstack) (lua_State *L, int sz);
void (lua_xmove) (lua_State *from, lua_State *to, int n);
int (lua_isnumber) (lua_State *L, int idx);
int (lua_isstring) (lua_State *L, int idx);
int (lua_iscfunction) (lua_State *L, int idx);
int (lua_isuserdata) (lua_State *L, int idx);
int (lua_type) (lua_State *L, int idx);
const char *(lua_typename) (lua_State *L, int tp);
int (lua_equal) (lua_State *L, int idx1, int idx2);
int (lua_rawequal) (lua_State *L, int idx1, int idx2);
int (lua_lessthan) (lua_State *L, int idx1, int idx2);
lua_Number (lua_tonumber) (lua_State *L, int idx);
lua_Integer (lua_tointeger) (lua_State *L, int idx);
int (lua_toboolean) (lua_State *L, int idx);
const char *(lua_tolstring) (lua_State *L, int idx, size_t *len);
size_t (lua_objlen) (lua_State *L, int idx);
lua_CFunction (lua_tocfunction) (lua_State *L, int idx);
void *(lua_touserdata) (lua_State *L, int idx);
lua_State *(lua_tothread) (lua_State *L, int idx);
const void *(lua_topointer) (lua_State *L, int idx);
void (lua_pushnil) (lua_State *L);
void (lua_pushnumber) (lua_State *L, lua_Number n);
void (lua_pushinteger) (lua_State *L, lua_Integer n);
void (lua_pushlstring) (lua_State *L, const char *s, size_t l);
void (lua_pushstring) (lua_State *L, const char *s);
const char *(lua_pushvfstring) (lua_State *L, const char *fmt,
                                                      va_list argp);
const char *(lua_pushfstring) (lua_State *L, const char *fmt, ...);
void (lua_pushcclosure) (lua_State *L, lua_CFunction fn, int n);
void (lua_pushboolean) (lua_State *L, int b);
void (lua_pushlightuserdata) (lua_State *L, void *p);
int (lua_pushthread) (lua_State *L);
void (lua_gettable) (lua_State *L, int idx);
void (lua_getfield) (lua_State *L, int idx, const char *k);
void (lua_rawget) (lua_State *L, int idx);
void (lua_rawgeti) (lua_State *L, int idx, int n);
void (lua_createtable) (lua_State *L, int narr, int nrec);
void *(lua_newuserdata) (lua_State *L, size_t sz);
int (lua_getmetatable) (lua_State *L, int objindex);
void (lua_getfenv) (lua_State *L, int idx);
void (lua_settable) (lua_State *L, int idx);
void (lua_setfield) (lua_State *L, int idx, const char *k);
void (lua_rawset) (lua_State *L, int idx);
void (lua_rawseti) (lua_State *L, int idx, int n);
int (lua_setmetatable) (lua_State *L, int objindex);
int (lua_setfenv) (lua_State *L, int idx);
void (lua_call) (lua_State *L, int nargs, int nresults);
int (lua_pcall) (lua_State *L, int nargs, int nresults, int errfunc);
int (lua_cpcall) (lua_State *L, lua_CFunction func, void *ud);
int (lua_load) (lua_State *L, lua_Reader reader, void *dt,
                                        const char *chunkname);
int (lua_dump) (lua_State *L, lua_Writer writer, void *data);
int (lua_yield) (lua_State *L, int nresults);
int (lua_resume) (lua_State *L, int narg);
int (lua_status) (lua_State *L);
int (lua_gc) (lua_State *L, int what, int data);
int (lua_error) (lua_State *L);
int (lua_next) (lua_State *L, int idx);
void (lua_concat) (lua_State *L, int n);
lua_Alloc (lua_getallocf) (lua_State *L, void **ud);
void lua_setallocf (lua_State *L, lua_Alloc f, void *ud);
void lua_setlevel (lua_State *from, lua_State *to);
typedef struct lua_Debug lua_Debug;
typedef void (*lua_Hook) (lua_State *L, lua_Debug *ar);
int lua_getstack (lua_State *L, int level, lua_Debug *ar);
int lua_getinfo (lua_State *L, const char *what, lua_Debug *ar);
const char *lua_getlocal (lua_State *L, const lua_Debug *ar, int n);
const char *lua_setlocal (lua_State *L, const lua_Debug *ar, int n);
const char *lua_getupvalue (lua_State *L, int funcindex, int n);
const char *lua_setupvalue (lua_State *L, int funcindex, int n);
int lua_sethook (lua_State *L, lua_Hook func, int mask, int count);
lua_Hook lua_gethook (lua_State *L);
int lua_gethookmask (lua_State *L);
int lua_gethookcount (lua_State *L);
void *lua_upvalueid (lua_State *L, int idx, int n);
void lua_upvaluejoin (lua_State *L, int idx1, int n1, int idx2, int n2);
int lua_loadx (lua_State *L, lua_Reader reader, void *dt,
         const char *chunkname, const char *mode);
const lua_Number *lua_version (lua_State *L);
void lua_copy (lua_State *L, int fromidx, int toidx);
lua_Number lua_tonumberx (lua_State *L, int idx, int *isnum);
lua_Integer lua_tointegerx (lua_State *L, int idx, int *isnum);
int lua_isyieldable (lua_State *L);
struct lua_Debug {
  int event;
  const char *name;
  const char *namewhat;
  const char *what;
  const char *source;
  int currentline;
  int nups;
  int linedefined;
  int lastlinedefined;
  char short_src[60];
  int i_ci;
};
int luaopen_base(lua_State *L);
int luaopen_math(lua_State *L);
int luaopen_string(lua_State *L);
int luaopen_table(lua_State *L);
int luaopen_io(lua_State *L);
int luaopen_os(lua_State *L);
int luaopen_package(lua_State *L);
int luaopen_debug(lua_State *L);
int luaopen_bit(lua_State *L);
int luaopen_jit(lua_State *L);
int luaopen_ffi(lua_State *L);
void luaL_openlibs(lua_State *L);

//lauxlib

typedef long int ptrdiff_t;
typedef long unsigned int size_t;
typedef int wchar_t;
typedef __builtin_va_list va_list;
typedef __builtin_va_list __gnuc_va_list;

typedef unsigned char __u_char;
typedef unsigned short int __u_short;
typedef unsigned int __u_int;
typedef unsigned long int __u_long;
typedef signed char __int8_t;
typedef unsigned char __uint8_t;
typedef signed short int __int16_t;
typedef unsigned short int __uint16_t;
typedef signed int __int32_t;
typedef unsigned int __uint32_t;
typedef signed long int __int64_t;
typedef unsigned long int __uint64_t;
typedef __int8_t __int_least8_t;
typedef __uint8_t __uint_least8_t;
typedef __int16_t __int_least16_t;
typedef __uint16_t __uint_least16_t;
typedef __int32_t __int_least32_t;
typedef __uint32_t __uint_least32_t;
typedef __int64_t __int_least64_t;
typedef __uint64_t __uint_least64_t;
typedef long int __quad_t;
typedef unsigned long int __u_quad_t;
typedef long int __intmax_t;
typedef unsigned long int __uintmax_t;
typedef unsigned long int __dev_t;
typedef unsigned int __uid_t;
typedef unsigned int __gid_t;
typedef unsigned long int __ino_t;
typedef unsigned long int __ino64_t;
typedef unsigned int __mode_t;
typedef unsigned long int __nlink_t;
typedef long int __off_t;
typedef long int __off64_t;
typedef int __pid_t;
typedef struct { int __val[2]; } __fsid_t;
typedef long int __clock_t;
typedef unsigned long int __rlim_t;
typedef unsigned long int __rlim64_t;
typedef unsigned int __id_t;
typedef long int __time_t;
typedef unsigned int __useconds_t;
typedef long int __suseconds_t;
typedef long int __suseconds64_t;
typedef int __daddr_t;
typedef int __key_t;
typedef int __clockid_t;
typedef void * __timer_t;
typedef long int __blksize_t;
typedef long int __blkcnt_t;
typedef long int __blkcnt64_t;
typedef unsigned long int __fsblkcnt_t;
typedef unsigned long int __fsblkcnt64_t;
typedef unsigned long int __fsfilcnt_t;
typedef unsigned long int __fsfilcnt64_t;
typedef long int __fsword_t;
typedef long int __ssize_t;
typedef long int __syscall_slong_t;
typedef unsigned long int __syscall_ulong_t;
typedef __off64_t __loff_t;
typedef char *__caddr_t;
typedef long int __intptr_t;
typedef unsigned int __socklen_t;
typedef int __sig_atomic_t;
typedef struct
{
  int __count;
  union
  {
    unsigned int __wch;
    char __wchb[4];
  } __value;
} __mbstate_t;
typedef struct _G_fpos_t
{
  __off_t __pos;
  __mbstate_t __state;
} __fpos_t;
typedef struct _G_fpos64_t
{
  __off64_t __pos;
  __mbstate_t __state;
} __fpos64_t;
struct _IO_FILE;
typedef struct _IO_FILE __FILE;
struct _IO_FILE;
typedef struct _IO_FILE FILE;
struct _IO_FILE;
struct _IO_marker;
struct _IO_codecvt;
struct _IO_wide_data;
typedef void _IO_lock_t;
struct _IO_FILE
{
  int _flags;
  char *_IO_read_ptr;
  char *_IO_read_end;
  char *_IO_read_base;
  char *_IO_write_base;
  char *_IO_write_ptr;
  char *_IO_write_end;
  char *_IO_buf_base;
  char *_IO_buf_end;
  char *_IO_save_base;
  char *_IO_backup_base;
  char *_IO_save_end;
  struct _IO_marker *_markers;
  struct _IO_FILE *_chain;
  int _fileno;
  int _flags2;
  __off_t _old_offset;
  unsigned short _cur_column;
  signed char _vtable_offset;
  char _shortbuf[1];
  _IO_lock_t *_lock;
  __off64_t _offset;
  struct _IO_codecvt *_codecvt;
  struct _IO_wide_data *_wide_data;
  struct _IO_FILE *_freeres_list;
  void *_freeres_buf;
  size_t __pad5;
  int _mode;
  char _unused2[15 * sizeof (int) - 4 * sizeof (void *) - sizeof (size_t)];
};
typedef __fpos_t fpos_t;
FILE *stdin;
FILE *stdout;
FILE *stderr;
int remove (const char *__filename) __attribute__ ((__nothrow__ ));
int rename (const char *__old, const char *__new) __attribute__ ((__nothrow__ ));
int fclose (FILE *__stream);
FILE *tmpfile (void)
  __attribute__ ((__malloc__)) ;
char *tmpnam (char[20]) __attribute__ ((__nothrow__ )) ;
int fflush (FILE *__stream);
FILE *fopen (const char *__restrict __filename,
      const char *__restrict __modes)
  __attribute__ ((__malloc__)) ;
FILE *freopen (const char *__restrict __filename,
        const char *__restrict __modes,
        FILE *__restrict __stream) ;
void setbuf (FILE *__restrict __stream, char *__restrict __buf) __attribute__ ((__nothrow__ ));
int setvbuf (FILE *__restrict __stream, char *__restrict __buf,
      int __modes, size_t __n) __attribute__ ((__nothrow__ ));
int fprintf (FILE *__restrict __stream,
      const char *__restrict __format, ...);
int printf (const char *__restrict __format, ...);
int sprintf (char *__restrict __s,
      const char *__restrict __format, ...) __attribute__ ((__nothrow__));
int vfprintf (FILE *__restrict __s, const char *__restrict __format,
       __gnuc_va_list __arg);
int vprintf (const char *__restrict __format, __gnuc_va_list __arg);
int vsprintf (char *__restrict __s, const char *__restrict __format,
       __gnuc_va_list __arg) __attribute__ ((__nothrow__));
int snprintf (char *__restrict __s, size_t __maxlen,
       const char *__restrict __format, ...)
     __attribute__ ((__nothrow__)) __attribute__ ((__format__ (__printf__, 3, 4)));
int vsnprintf (char *__restrict __s, size_t __maxlen,
        const char *__restrict __format, __gnuc_va_list __arg)
     __attribute__ ((__nothrow__)) __attribute__ ((__format__ (__printf__, 3, 0)));
int fscanf (FILE *__restrict __stream,
     const char *__restrict __format, ...) ;
int scanf (const char *__restrict __format, ...) ;
int sscanf (const char *__restrict __s,
     const char *__restrict __format, ...) __attribute__ ((__nothrow__ ));
typedef float _Float32;
typedef double _Float64;
typedef double _Float32x;
typedef long double _Float64x;
int fscanf (FILE *__restrict __stream, const char *__restrict __format, ...) __asm__ ("" "__isoc99_fscanf") ;
int scanf (const char *__restrict __format, ...) __asm__ ("" "__isoc99_scanf") ;
int sscanf (const char *__restrict __s, const char *__restrict __format, ...) __asm__ ("" "__isoc99_sscanf") __attribute__ ((__nothrow__ ));
int vfscanf (FILE *__restrict __s, const char *__restrict __format,
      __gnuc_va_list __arg)
     __attribute__ ((__format__ (__scanf__, 2, 0))) ;
int vscanf (const char *__restrict __format, __gnuc_va_list __arg)
     __attribute__ ((__format__ (__scanf__, 1, 0))) ;
int vsscanf (const char *__restrict __s,
      const char *__restrict __format, __gnuc_va_list __arg)
     __attribute__ ((__nothrow__ )) __attribute__ ((__format__ (__scanf__, 2, 0)));
int vfscanf (FILE *__restrict __s, const char *__restrict __format, __gnuc_va_list __arg) __asm__ ("" "__isoc99_vfscanf")
     __attribute__ ((__format__ (__scanf__, 2, 0))) ;
int vscanf (const char *__restrict __format, __gnuc_va_list __arg) __asm__ ("" "__isoc99_vscanf")
     __attribute__ ((__format__ (__scanf__, 1, 0))) ;
int vsscanf (const char *__restrict __s, const char *__restrict __format, __gnuc_va_list __arg) __asm__ ("" "__isoc99_vsscanf") __attribute__ ((__nothrow__ ))
     __attribute__ ((__format__ (__scanf__, 2, 0)));
int fgetc (FILE *__stream);
int getc (FILE *__stream);
int getchar (void);
int fputc (int __c, FILE *__stream);
int putc (int __c, FILE *__stream);
int putchar (int __c);
char *fgets (char *__restrict __s, int __n, FILE *__restrict __stream)
                                                         ;
char *gets (char *__s) __attribute__ ((__deprecated__));
int fputs (const char *__restrict __s, FILE *__restrict __stream);
int puts (const char *__s);
int ungetc (int __c, FILE *__stream);
size_t fread (void *__restrict __ptr, size_t __size,
       size_t __n, FILE *__restrict __stream) ;
size_t fwrite (const void *__restrict __ptr, size_t __size,
        size_t __n, FILE *__restrict __s);
int fseek (FILE *__stream, long int __off, int __whence);
long int ftell (FILE *__stream) ;
void rewind (FILE *__stream);
int fgetpos (FILE *__restrict __stream, fpos_t *__restrict __pos);
int fsetpos (FILE *__stream, const fpos_t *__pos);
void clearerr (FILE *__stream) __attribute__ ((__nothrow__ ));
int feof (FILE *__stream) __attribute__ ((__nothrow__ )) ;
int ferror (FILE *__stream) __attribute__ ((__nothrow__ )) ;
void perror (const char *__s);
int __uflow (FILE *);
int __overflow (FILE *, int);

typedef struct lua_State lua_State;
typedef int (*lua_CFunction) (lua_State *L);
typedef const char * (*lua_Reader) (lua_State *L, void *ud, size_t *sz);
typedef int (*lua_Writer) (lua_State *L, const void* p, size_t sz, void* ud);
typedef void * (*lua_Alloc) (void *ud, void *ptr, size_t osize, size_t nsize);
typedef double lua_Number;
typedef ptrdiff_t lua_Integer;
lua_State *(lua_newstate) (lua_Alloc f, void *ud);
void (lua_close) (lua_State *L);
lua_State *(lua_newthread) (lua_State *L);
lua_CFunction (lua_atpanic) (lua_State *L, lua_CFunction panicf);
int (lua_gettop) (lua_State *L);
void (lua_settop) (lua_State *L, int idx);
void (lua_pushvalue) (lua_State *L, int idx);
void (lua_remove) (lua_State *L, int idx);
void (lua_insert) (lua_State *L, int idx);
void (lua_replace) (lua_State *L, int idx);
int (lua_checkstack) (lua_State *L, int sz);
void (lua_xmove) (lua_State *from, lua_State *to, int n);
int (lua_isnumber) (lua_State *L, int idx);
int (lua_isstring) (lua_State *L, int idx);
int (lua_iscfunction) (lua_State *L, int idx);
int (lua_isuserdata) (lua_State *L, int idx);
int (lua_type) (lua_State *L, int idx);
const char *(lua_typename) (lua_State *L, int tp);
int (lua_equal) (lua_State *L, int idx1, int idx2);
int (lua_rawequal) (lua_State *L, int idx1, int idx2);
int (lua_lessthan) (lua_State *L, int idx1, int idx2);
lua_Number (lua_tonumber) (lua_State *L, int idx);
lua_Integer (lua_tointeger) (lua_State *L, int idx);
int (lua_toboolean) (lua_State *L, int idx);
const char *(lua_tolstring) (lua_State *L, int idx, size_t *len);
size_t (lua_objlen) (lua_State *L, int idx);
lua_CFunction (lua_tocfunction) (lua_State *L, int idx);
void *(lua_touserdata) (lua_State *L, int idx);
lua_State *(lua_tothread) (lua_State *L, int idx);
const void *(lua_topointer) (lua_State *L, int idx);
void (lua_pushnil) (lua_State *L);
void (lua_pushnumber) (lua_State *L, lua_Number n);
void (lua_pushinteger) (lua_State *L, lua_Integer n);
void (lua_pushlstring) (lua_State *L, const char *s, size_t l);
void (lua_pushstring) (lua_State *L, const char *s);
const char *(lua_pushvfstring) (lua_State *L, const char *fmt,
                                                      va_list argp);
const char *(lua_pushfstring) (lua_State *L, const char *fmt, ...);
void (lua_pushcclosure) (lua_State *L, lua_CFunction fn, int n);
void (lua_pushboolean) (lua_State *L, int b);
void (lua_pushlightuserdata) (lua_State *L, void *p);
int (lua_pushthread) (lua_State *L);
void (lua_gettable) (lua_State *L, int idx);
void (lua_getfield) (lua_State *L, int idx, const char *k);
void (lua_rawget) (lua_State *L, int idx);
void (lua_rawgeti) (lua_State *L, int idx, int n);
void (lua_createtable) (lua_State *L, int narr, int nrec);
void *(lua_newuserdata) (lua_State *L, size_t sz);
int (lua_getmetatable) (lua_State *L, int objindex);
void (lua_getfenv) (lua_State *L, int idx);
void (lua_settable) (lua_State *L, int idx);
void (lua_setfield) (lua_State *L, int idx, const char *k);
void (lua_rawset) (lua_State *L, int idx);
void (lua_rawseti) (lua_State *L, int idx, int n);
int (lua_setmetatable) (lua_State *L, int objindex);
int (lua_setfenv) (lua_State *L, int idx);
void (lua_call) (lua_State *L, int nargs, int nresults);
int (lua_pcall) (lua_State *L, int nargs, int nresults, int errfunc);
int (lua_cpcall) (lua_State *L, lua_CFunction func, void *ud);
int (lua_load) (lua_State *L, lua_Reader reader, void *dt,
                                        const char *chunkname);
int (lua_dump) (lua_State *L, lua_Writer writer, void *data);
int (lua_yield) (lua_State *L, int nresults);
int (lua_resume) (lua_State *L, int narg);
int (lua_status) (lua_State *L);
int (lua_gc) (lua_State *L, int what, int data);
int (lua_error) (lua_State *L);
int (lua_next) (lua_State *L, int idx);
void (lua_concat) (lua_State *L, int n);
lua_Alloc (lua_getallocf) (lua_State *L, void **ud);
void lua_setallocf (lua_State *L, lua_Alloc f, void *ud);
void lua_setlevel (lua_State *from, lua_State *to);
typedef struct lua_Debug lua_Debug;
typedef void (*lua_Hook) (lua_State *L, lua_Debug *ar);
int lua_getstack (lua_State *L, int level, lua_Debug *ar);
int lua_getinfo (lua_State *L, const char *what, lua_Debug *ar);
const char *lua_getlocal (lua_State *L, const lua_Debug *ar, int n);
const char *lua_setlocal (lua_State *L, const lua_Debug *ar, int n);
const char *lua_getupvalue (lua_State *L, int funcindex, int n);
const char *lua_setupvalue (lua_State *L, int funcindex, int n);
int lua_sethook (lua_State *L, lua_Hook func, int mask, int count);
lua_Hook lua_gethook (lua_State *L);
int lua_gethookmask (lua_State *L);
int lua_gethookcount (lua_State *L);
void *lua_upvalueid (lua_State *L, int idx, int n);
void lua_upvaluejoin (lua_State *L, int idx1, int n1, int idx2, int n2);
int lua_loadx (lua_State *L, lua_Reader reader, void *dt,
         const char *chunkname, const char *mode);
const lua_Number *lua_version (lua_State *L);
void lua_copy (lua_State *L, int fromidx, int toidx);
lua_Number lua_tonumberx (lua_State *L, int idx, int *isnum);
lua_Integer lua_tointegerx (lua_State *L, int idx, int *isnum);
int lua_isyieldable (lua_State *L);
struct lua_Debug {
  int event;
  const char *name;
  const char *namewhat;
  const char *what;
  const char *source;
  int currentline;
  int nups;
  int linedefined;
  int lastlinedefined;
  char short_src[60];
  int i_ci;
};
typedef struct luaL_Reg {
  const char *name;
  lua_CFunction func;
} luaL_Reg;
void (luaL_openlib) (lua_State *L, const char *libname,
                                const luaL_Reg *l, int nup);
void (luaL_register) (lua_State *L, const char *libname,
                                const luaL_Reg *l);
int (luaL_getmetafield) (lua_State *L, int obj, const char *e);
int (luaL_callmeta) (lua_State *L, int obj, const char *e);
int (luaL_typerror) (lua_State *L, int narg, const char *tname);
int (luaL_argerror) (lua_State *L, int numarg, const char *extramsg);
const char *(luaL_checklstring) (lua_State *L, int numArg,
                                                          size_t *l);
const char *(luaL_optlstring) (lua_State *L, int numArg,
                                          const char *def, size_t *l);
lua_Number (luaL_checknumber) (lua_State *L, int numArg);
lua_Number (luaL_optnumber) (lua_State *L, int nArg, lua_Number def);
lua_Integer (luaL_checkinteger) (lua_State *L, int numArg);
lua_Integer (luaL_optinteger) (lua_State *L, int nArg,
                                          lua_Integer def);
void (luaL_checkstack) (lua_State *L, int sz, const char *msg);
void (luaL_checktype) (lua_State *L, int narg, int t);
void (luaL_checkany) (lua_State *L, int narg);
int (luaL_newmetatable) (lua_State *L, const char *tname);
void *(luaL_checkudata) (lua_State *L, int ud, const char *tname);
void (luaL_where) (lua_State *L, int lvl);
int (luaL_error) (lua_State *L, const char *fmt, ...);
int (luaL_checkoption) (lua_State *L, int narg, const char *def,
                                   const char *const lst[]);
int (luaL_ref) (lua_State *L, int t);
void (luaL_unref) (lua_State *L, int t, int ref);
int (luaL_loadfile) (lua_State *L, const char *filename);
int (luaL_loadbuffer) (lua_State *L, const char *buff, size_t sz,
                                  const char *name);
int (luaL_loadstring) (lua_State *L, const char *s);
lua_State *(luaL_newstate) (void);
const char *(luaL_gsub) (lua_State *L, const char *s, const char *p,
                                                  const char *r);
const char *(luaL_findtable) (lua_State *L, int idx,
                                         const char *fname, int szhint);
int luaL_fileresult(lua_State *L, int stat, const char *fname);
int luaL_execresult(lua_State *L, int stat);
int (luaL_loadfilex) (lua_State *L, const char *filename,
     const char *mode);
int (luaL_loadbufferx) (lua_State *L, const char *buff, size_t sz,
       const char *name, const char *mode);
void luaL_traceback (lua_State *L, lua_State *L1, const char *msg,
    int level);
void (luaL_setfuncs) (lua_State *L, const luaL_Reg *l, int nup);
void (luaL_pushmodule) (lua_State *L, const char *modname,
       int sizehint);
void *(luaL_testudata) (lua_State *L, int ud, const char *tname);
void (luaL_setmetatable) (lua_State *L, const char *tname);
typedef struct luaL_Buffer {
  char *p;
  int lvl;
  lua_State *L;
  char buffer[8192];
} luaL_Buffer;
void (luaL_buffinit) (lua_State *L, luaL_Buffer *B);
char *(luaL_prepbuffer) (luaL_Buffer *B);
void (luaL_addlstring) (luaL_Buffer *B, const char *s, size_t l);
void (luaL_addstring) (luaL_Buffer *B, const char *s);
void (luaL_addvalue) (luaL_Buffer *B);
void (luaL_pushresult) (luaL_Buffer *B);
