# devise-ftp

This is a small program intended to perform FTP authentication against users of the [Devise](https://github.com/plataformatec/devise) gem by the Brazilian shop Plataforma. The salient consideration is that we would like to authenticate the login credentials supplied to our FTP server without queueing up the entire Rails stack, as that would be quite costly from a time perspective, relative to other forms of FTP authentication.

This is a delivery-room proram. Mewling and puking and all that. Feel free to use it under the Do-Whatever-You-Like License, but just know that newborns are not exactly known for their robustness.


## Setup

This works with Pure-FTP. For instructions on setting up Pure-FTP, go [here](http://www.pureftp.org/project/pure-ftp/doc).

Once your server is setup, amend the script to use the appropriate UID and GID for the Unix user under which you would like your application users to operate. Change the directory to use the directory you would like them to be chrooted to. Please, in the name of good sense, do not use your application's public directory as your chroot, even if your goal is to allow your users to upload photos and other such downloadables. If you do, don't be surprised when your users start uploading Ruby scripts which are now web-accessible, thus enabling your server to start running arbitrary Ruby code on your machine.

You will also want to change the script to point to the appropriate section of your database.yml configuration file, as I have it hardcoded to 'development' (hey, I said this thing was not particularly mature).

Launch the pure-authd daemon using this script as an option with -r. Make sure the pure-ftpd daemon is configured to use its external authentication module (extauth) as one of its means of authentication

```bash
sudo pure-authd -s /var/run/ftpd.sock -r /path/to/this/script/ftp.rb &
sudo pure-ftpd -lextauth:/var/run/ftpd.sock &
```

## Roadmap

In no particular order, plans with this are:

1. Packaging in rubygems, at which point it can be included in a proper dependency management policy instead of simply cloning some random GitHub repo.
2. Support for pepper hashes configured under Devise
3. Support for certain Devise extensions, e.g. [devise-encryptable](https://github.com/plataformatec/devise-encryptable) and [devise_aes_encryptable](https://github.com/chicks/devise_aes_encryptable)
