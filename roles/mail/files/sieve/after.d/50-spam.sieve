#
# /usr/local/etc/dovecot/sieve/after.d/50-spam.sieve
#
# Global filters to filter spams.
#
# See: https://wiki.dovecot.org/Pigeonhole/Sieve
#
# Aaron LI
# 2017-04-24
#


# fileinto: place messages into an IMAP folder other than INBOX
require "fileinto";
# mailbox: create the IMAP folder if not exists
require "mailbox";
# imap4flags: add IMAP flags to stored messages
require "imap4flags";
 

# Just delete spams higher than level 10!
if header :contains "X-Spam-Level" "**********" {
    discard;
    stop;
}
 
# Move SpamAssassin-tagged mails to "Junk" folder.
if header :contains "X-Spam-Flag" "YES" {
    fileinto :create "Junk";
    setflag "\\Seen";
    stop;
}
