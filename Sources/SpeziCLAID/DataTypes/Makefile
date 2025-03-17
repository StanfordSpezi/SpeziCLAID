.PHONY: swift_datatypes
swift_datatypes: 
	protoc --swift_out=Visibility=Public:./ \
	--grpc-swift_out=Visibility=Public:./ \
	-I ./ speziclaid_datatypes.proto

.PHONY: python_datatypes
python_datatypes:
	protoc -I ./ --python_betterproto_out=../Python *.proto

.PHONY: datatypes
datatypes: swift_datatypes python_datatypes