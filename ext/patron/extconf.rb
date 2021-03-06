## -------------------------------------------------------------------
##
## Copyright (c) 2008 The Hive http://www.thehive.com/
##
## Permission is hereby granted, free of charge, to any person obtaining a copy
## of this software and associated documentation files (the "Software"), to deal
## in the Software without restriction, including without limitation the rights
## to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
## copies of the Software, and to permit persons to whom the Software is
## furnished to do so, subject to the following conditions:
##
## The above copyright notice and this permission notice shall be included in
## all copies or substantial portions of the Software.
##
## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
## IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
## FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
## AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
## LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
## OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
## THE SOFTWARE.
##
## -------------------------------------------------------------------


require 'mkmf'
require 'rbconfig'

dir_config('curl')
curl_config_path = with_config('curl-config') || find_executable('curl-config')
if curl_config_path
  $CFLAGS << " " << `#{curl_config_path} --cflags`.strip
  $LIBS << " " << `#{curl_config_path} --libs`.strip
elsif !have_library('curl') or !have_header('curl/curl.h')
  fail <<-EOM
  Can't find libcurl or curl/curl.h

  Try passing --with-curl-config, --with-curl-dir, or --with-curl-lib and --with-curl-include
  options to extconf.
  EOM
end

if CONFIG['CC'] =~ /gcc/
  $CFLAGS << ' -pedantic -Wall'
end

$defs.push("-DUSE_TBR")
$defs.push("-DHAVE_THREAD_H") if have_header('ruby/thread.h')
$defs.push("-DHAVE_TBR") if have_func('rb_thread_blocking_region', 'ruby.h')
$defs.push("-DHAVE_TCWOGVL") if have_header('ruby/thread.h') && have_func('rb_thread_call_without_gvl', 'ruby/thread.h')

create_makefile 'patron/session_ext'
