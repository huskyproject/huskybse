;-----------------------------------------------------------------------------
; Sample Msged message template file.
;-----------------------------------------------------------------------------
;
;-----------------------------------------------------------------------------
; If you have a template defined in msged.cfg, it will use the file to create
; a template when replying to and forwarding/redirecting messages.
;
; lines beginning with ';' are ignored.
;
; The normal tokens are the same as those used in the old form of message
; attributes.  Tokens begin with a '%' sign and you may place them anywhere
; you like within a line.  Please note that the fully expanded line must not
; be more that 250 chars (not a likely problem).
;
; Lines will be included into the resulting message depending on the
; attributes for the function (see config file).  The line tokens begin with
; '@' and have *one* following char that defines what type the line is.  The
; types of lines are:
;
;     @l      Followup (reply-comment) msgs.
;     @f      Forwarded msgs.
;     @r      Redirected msgs.
;     @n      New msgs (not forwarded or redirected).
;     @a      Messages appearing in a new area (replys only).
;     @q      Messages that include a quote.
;     @m      Includes the message text, quoted or not.
;
; Note that the letters are case-insensitive.
;
;-----------------------------------------------------------------------------
;
;-----------------------------------------------------------------------------
; Template Token Names
;
;    %yms - year msg
;    %yno - year now
;    %mms - month msg
;    %mno - month now
;    %dms - day msg
;    %dno - day now
;    %wms - weekday msg
;    %wno - weekday now
;    %tnm - time msg normal
;    %tnn - time now normal
;    %tam - time msg atime
;    %tan - time now atime
;    %ofn - orginal from name
;    %off - original from first name
;    %otn - original to name
;    %otf - original to first name
;    %osu - original subject
;    %ooa - original origin address
;    %oda - orginal destination address
;    %fna - from name
;    %ffn - from first name
;    %fad - from address
;    %tna - to name
;    %tfn - to first name
;    %tad - to address
;    %sub - subject
;    %una - current user name
;    %ufn - current user first name
;    %uad - current user address
;    %ceh - current echo tag (before area change)
;    %oeh - old echo tag
;-----------------------------------------------------------------------------
;
@f* Forwarded from %oeh by %una (%uad).
@f* Originally by: %ofn (%ooa), %dms %mms %yms %tnm.
@f* Originally to: %otn (%oda).
@f
@f---------- Forwarded message ----------
;
@r* Redirected by: %una (%uad).
@r* Originally to: %otn (%oda).
@r* Originally by: %ofn (%ooa), %dms %mms %yms %tnm.
@r
@r---------- Redirected message ----------
;
@l* Originally by: %ofn (%ooa), %dms %mms %yms %tnm.
@l
;
@a * Reply to message originally in area %oeh
@a
;
@nHi %tfn!
@n
;
; @q%mms %dms %tnm %yms, %ofn wrote to %otn:
@q%dms %mms %yms %tnm, %ofn wrote to %otn:
@q
;
@m
;
@n
@nCU/Lnx %ufn

Registered Linux User #77587 (http://counter.li.org)

;-----------------------------------------------------------------------------
