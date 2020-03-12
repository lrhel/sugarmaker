# try on virtualbox ubuntu 16.04
# https://gist.github.com/quagliero/90f493f123c7b1ddba5428ba0146329a

# CLEAN
make distclean || echo clean
rm -f config.status

# BUILD
./autogen.sh
# CFLAGS="-Wall -O2 -fomit-frame-pointer" CXXFLAGS="$CFLAGS -std=gnu++11" LDFLAGS="-static" ./configure --with-curl=/usr/local/
# ./configure CFLAGS="-march=native" --with-crypto=/usr/local/opt/openssl  --with-curl
# ./configure CFLAGS="-Wall -O2 -fomit-frame-pointer" --with-crypto=/usr/local/opt/openssl --with-curl
./configure CFLAGS="-Wall -O2 -fomit-frame-pointer" --with-crypto=/usr/local/opt/openssl --with-curl
make
strip sugarmaker

# CHECK STATIC
file sugarmaker | grep "statically linked"

# PACKAGE
RELEASE=sugarmaker-v2.5.0-sugar1-osx
rm -rf $RELEASE
mkdir $RELEASE
cp ./depends/sh/*.sh $RELEASE/
cp sugarmaker $RELEASE/

# SIGN
zip -r $RELEASE/$RELEASE.zip $RELEASE/*
# sha256sum $RELEASE/$RELEASE.zip > $RELEASE/$RELEASE
shasum -a 256 $RELEASE/$RELEASE.zip > $RELEASE/$RELEASE
gpg --digest-algo sha256 --clearsign $RELEASE/$RELEASE
rm $RELEASE/$RELEASE && cat $RELEASE/$RELEASE.asc
