import * as jspb from 'google-protobuf'



export class CalculateRequest extends jspb.Message {
  getNumber1(): number;
  setNumber1(value: number): CalculateRequest;

  getNumber2(): number;
  setNumber2(value: number): CalculateRequest;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): CalculateRequest.AsObject;
  static toObject(includeInstance: boolean, msg: CalculateRequest): CalculateRequest.AsObject;
  static serializeBinaryToWriter(message: CalculateRequest, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): CalculateRequest;
  static deserializeBinaryFromReader(message: CalculateRequest, reader: jspb.BinaryReader): CalculateRequest;
}

export namespace CalculateRequest {
  export type AsObject = {
    number1: number,
    number2: number,
  }
}

export class CalculateReply extends jspb.Message {
  getResult(): number;
  setResult(value: number): CalculateReply;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): CalculateReply.AsObject;
  static toObject(includeInstance: boolean, msg: CalculateReply): CalculateReply.AsObject;
  static serializeBinaryToWriter(message: CalculateReply, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): CalculateReply;
  static deserializeBinaryFromReader(message: CalculateReply, reader: jspb.BinaryReader): CalculateReply;
}

export namespace CalculateReply {
  export type AsObject = {
    result: number,
  }
}