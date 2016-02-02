# This generates the Protobuf libraries from source.

# All .py files depend on their respective .proto files.
py_rekall_files := $(patsubst %.proto,%_pb2.py,$(wildcard client/components/rekall_support/*.proto))
py_files := $(patsubst %.proto,%_pb2.py,$(wildcard proto/*.proto))
cc_files := $(patsubst %.proto,%.pb.cc,$(wildcard proto/*.proto))

# Allow the location to the proto compiler to be specified.
ifndef PROTOC
  PROTOC=protoc
endif

ifndef PROTO_SRC_ROOT
  PROTO_SRC_ROOT=/usr/include/
endif

PROTOPATH = --proto_path=. --proto_path=.. --proto_path=$(PROTO_SRC_ROOT)

# Make all python/cpp files from any proto files found here.
all: version_check $(py_files) $(cc_files) $(py_rekall_files)

# The compiler version used to create protos must match the protobuf version in
# client/*/requirements.txt
version_check:
	@if [ "$$($(PROTOC) --version)" != "libprotoc 2.6.1" ]; then \
	  echo 'Bad proto compiler version, we need 2.6.1'; \
	  exit 1; \
	fi

%_pb2.py: %.proto
	$(PROTOC) --python_out=. $(PROTOPATH) $?

%.pb.cc: %.proto
	$(PROTOC) --cpp_out=. $(PROTOPATH) $?

.PHONY: sync clean
clean:
	rm -f $(py_files) $(cc_files) $(py_rekall_files) proto/*.pyc proto/*.pb.h