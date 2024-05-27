# Membermojo

_The following was provided by MemberMojo via email._

The members.csv file can be downloaded using a script that signs in, captures the session cookie, then uses that to download the file.

Script to sign in and download the members file

```shell
curl -sS --cookie cookies.txt --cookie-jar cookies.txt --output signin.html --data 'email=<email>&password=<password>' https://membermojo.co.uk/<shortname>/signin_password
curl -sS --cookie cookies.txt --output members.csv https://membermojo.co.uk/<shortname>/membership/download_members
```

The first command signs in and grabs a session cookie and the second fetches the file. The session cookie will timeout after 60 mins of inactivity.

We'd recommend setting up a read-only admin account with a strong password just for this download.

If your password contains special characters it may need URL encoding before adding to the script.

**Browser Verification**

All admins must verify their browser using a link sent by email in addition to the email and password.

The additional verification also applies to scripted member.csv downloads, but there are two choices:

Using a browser verification cookie. To verify using cookies see below.
IP address whitelisting. We can whitelist 1 or 2 static IP addresses for your script so that browser verification by email is not required. To white list please confirm the email address used with your script, the static IP address it will connect from and that the IP address is not shared with other sites.
Script to fetch the verification cookie

There are a couple of extra steps to fetch the verification cookie that can then be used for download.

Run the download script above which will fail the first time due to browser verification - but send you a verification email.

Run the following to extract a CSRF token:

```shell
curl -sS --cookie cookies.txt --cookie-jar cookies.txt 'https://membermojo.co.uk' | sed -En 's/^.*"csrf_token":"([^"]+).*$/\1/p'
```
Copy/paste the CSRF token and link from the verification email into the following:

```shell
curl -sS --cookie cookies.txt --cookie-jar cookies.txt --output verify.html --data 'csrf_token=<csrf-token>' '<verification-link>'
```
This will fetch the verification cookie and store it in cookie.txt used by the download script. Note that the verification link can only be used once.

It should now be possible to re-run the download script without the need for verification. If there is a long period (over a month) between downloads you may need to obtain a new verification cookie. If the email address or password used for the download is changed a new verification cookie will be required.

For other verification issues please see https://membermojo.co.uk/mm/help/welcome/browser-verification
