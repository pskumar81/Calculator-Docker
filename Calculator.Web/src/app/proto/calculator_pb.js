// Mock implementation for the proto generated files
// In a real project, these would be generated using protoc with the grpc-web plugin

export class CalculateRequest {
  constructor() {
    this.number1_ = 0;
    this.number2_ = 0;
  }

  getNumber1() {
    return this.number1_;
  }

  setNumber1(value) {
    this.number1_ = value;
    return this;
  }

  getNumber2() {
    return this.number2_;
  }

  setNumber2(value) {
    this.number2_ = value;
    return this;
  }

  serializeBinary() {
    // Mock serialization - in real implementation this would serialize to protobuf binary
    return new Uint8Array();
  }

  static deserializeBinary(bytes) {
    return new CalculateRequest();
  }
}

export class CalculateReply {
  constructor() {
    this.result_ = 0;
  }

  getResult() {
    return this.result_;
  }

  setResult(value) {
    this.result_ = value;
    return this;
  }

  serializeBinary() {
    // Mock serialization - in real implementation this would serialize to protobuf binary
    return new Uint8Array();
  }

  static deserializeBinary(bytes) {
    const reply = new CalculateReply();
    // Mock deserialization - would parse from protobuf binary
    return reply;
  }
}