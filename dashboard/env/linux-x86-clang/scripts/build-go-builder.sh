set -ex

export GOPATH=/gopath
export GOROOT=/goroot
PREFIX=/usr/local
: ${GO_REV:?"need to be set to the golang repo revision used to build the builder."}
: ${BUILDER_REV:?"need to be set to the go.tools repo revision for the builder."}

mkdir -p $GOROOT
git clone https://go.googlesource.com/go $GOROOT
(cd $GOROOT/src && git checkout $GO_REV && find && ./make.bash)

GO_TOOLS=$GOPATH/src/github.com/Go-zh/tools
mkdir -p $GO_TOOLS
git clone https://go.googlesource.com/tools $GO_TOOLS

mkdir -p $PREFIX/bin
(cd $GO_TOOLS && git reset --hard $BUILDER_REV && GOBIN=$PREFIX/bin /goroot/bin/go install github.com/Go-zh/tools/dashboard/builder)

rm -fR $GOROOT/bin $GOROOT/pkg $GOPATH

cd $GOROOT
git clean -f -d -x
git checkout master
