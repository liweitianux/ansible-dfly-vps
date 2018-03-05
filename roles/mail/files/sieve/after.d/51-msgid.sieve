#
# /usr/local/etc/dovecot/sieve/after.d/51-msgid.sieve
#
# Global filters to filter messages with invalid "message-id".
#
# Aaron LI
# 2017-04-24
#

 
require "fileinto";
require "mailbox";
require "imap4flags";
require "regex";


# Trash messages with improperly formed "message-id"
if not header :regex "message-id" ".*@.*\\." {
    fileinto :create "Trash";
    setflag "\\Seen";
    stop;
}
