/**
 * @fileoverview gRPC-Web generated client stub for calculator
 * @enhanceable
 * @public
 */

// GENERATED CODE -- DO NOT EDIT!


/* eslint-disable */
// @ts-nocheck


import * as grpcWeb from 'grpc-web';

import * as calculator_pb from './calculator_pb';


export class CalculatorServiceClient {
  client_: grpcWeb.AbstractClientBase;
  hostname_: string;
  credentials_: null | { [index: string]: string; };
  options_: null | { [index: string]: any; };

  constructor (hostname: string,
               credentials?: null | { [index: string]: string; },
               options?: null | { [index: string]: any; }) {
    if (!options) options = {};
    if (!credentials) credentials = {};
    options['format'] = 'text';

    this.client_ = new grpcWeb.GrpcWebClientBase(options);
    this.hostname_ = hostname;
    this.credentials_ = credentials;
    this.options_ = options;
  }

  methodDescriptorAdd = new grpcWeb.MethodDescriptor(
    '/calculator.CalculatorService/Add',
    grpcWeb.MethodType.UNARY,
    calculator_pb.CalculateRequest,
    calculator_pb.CalculateReply,
    (request: calculator_pb.CalculateRequest) => {
      return request.serializeBinary();
    },
    calculator_pb.CalculateReply.deserializeBinary
  );

  add(
    request: calculator_pb.CalculateRequest,
    metadata: grpcWeb.Metadata | null): Promise<calculator_pb.CalculateReply>;

  add(
    request: calculator_pb.CalculateRequest,
    metadata: grpcWeb.Metadata | null,
    callback: (err: grpcWeb.RpcError,
               response: calculator_pb.CalculateReply) => void): grpcWeb.ClientReadableStream<calculator_pb.CalculateReply>;

  add(
    request: calculator_pb.CalculateRequest,
    metadata: grpcWeb.Metadata | null,
    callback?: (err: grpcWeb.RpcError,
               response: calculator_pb.CalculateReply) => void) {
    if (callback !== undefined) {
      return this.client_.rpcCall(
        this.hostname_ +
          '/calculator.CalculatorService/Add',
        request,
        metadata || {},
        this.methodDescriptorAdd,
        callback);
    }
    return this.client_.unaryCall(
    this.hostname_ +
      '/calculator.CalculatorService/Add',
    request,
    metadata || {},
    this.methodDescriptorAdd);
  }

  methodDescriptorSubtract = new grpcWeb.MethodDescriptor(
    '/calculator.CalculatorService/Subtract',
    grpcWeb.MethodType.UNARY,
    calculator_pb.CalculateRequest,
    calculator_pb.CalculateReply,
    (request: calculator_pb.CalculateRequest) => {
      return request.serializeBinary();
    },
    calculator_pb.CalculateReply.deserializeBinary
  );

  subtract(
    request: calculator_pb.CalculateRequest,
    metadata: grpcWeb.Metadata | null): Promise<calculator_pb.CalculateReply>;

  subtract(
    request: calculator_pb.CalculateRequest,
    metadata: grpcWeb.Metadata | null,
    callback: (err: grpcWeb.RpcError,
               response: calculator_pb.CalculateReply) => void): grpcWeb.ClientReadableStream<calculator_pb.CalculateReply>;

  subtract(
    request: calculator_pb.CalculateRequest,
    metadata: grpcWeb.Metadata | null,
    callback?: (err: grpcWeb.RpcError,
               response: calculator_pb.CalculateReply) => void) {
    if (callback !== undefined) {
      return this.client_.rpcCall(
        this.hostname_ +
          '/calculator.CalculatorService/Subtract',
        request,
        metadata || {},
        this.methodDescriptorSubtract,
        callback);
    }
    return this.client_.unaryCall(
    this.hostname_ +
      '/calculator.CalculatorService/Subtract',
    request,
    metadata || {},
    this.methodDescriptorSubtract);
  }

  methodDescriptorMultiply = new grpcWeb.MethodDescriptor(
    '/calculator.CalculatorService/Multiply',
    grpcWeb.MethodType.UNARY,
    calculator_pb.CalculateRequest,
    calculator_pb.CalculateReply,
    (request: calculator_pb.CalculateRequest) => {
      return request.serializeBinary();
    },
    calculator_pb.CalculateReply.deserializeBinary
  );

  multiply(
    request: calculator_pb.CalculateRequest,
    metadata: grpcWeb.Metadata | null): Promise<calculator_pb.CalculateReply>;

  multiply(
    request: calculator_pb.CalculateRequest,
    metadata: grpcWeb.Metadata | null,
    callback: (err: grpcWeb.RpcError,
               response: calculator_pb.CalculateReply) => void): grpcWeb.ClientReadableStream<calculator_pb.CalculateReply>;

  multiply(
    request: calculator_pb.CalculateRequest,
    metadata: grpcWeb.Metadata | null,
    callback?: (err: grpcWeb.RpcError,
               response: calculator_pb.CalculateReply) => void) {
    if (callback !== undefined) {
      return this.client_.rpcCall(
        this.hostname_ +
          '/calculator.CalculatorService/Multiply',
        request,
        metadata || {},
        this.methodDescriptorMultiply,
        callback);
    }
    return this.client_.unaryCall(
    this.hostname_ +
      '/calculator.CalculatorService/Multiply',
    request,
    metadata || {},
    this.methodDescriptorMultiply);
  }

  methodDescriptorDivide = new grpcWeb.MethodDescriptor(
    '/calculator.CalculatorService/Divide',
    grpcWeb.MethodType.UNARY,
    calculator_pb.CalculateRequest,
    calculator_pb.CalculateReply,
    (request: calculator_pb.CalculateRequest) => {
      return request.serializeBinary();
    },
    calculator_pb.CalculateReply.deserializeBinary
  );

  divide(
    request: calculator_pb.CalculateRequest,
    metadata: grpcWeb.Metadata | null): Promise<calculator_pb.CalculateReply>;

  divide(
    request: calculator_pb.CalculateRequest,
    metadata: grpcWeb.Metadata | null,
    callback: (err: grpcWeb.RpcError,
               response: calculator_pb.CalculateReply) => void): grpcWeb.ClientReadableStream<calculator_pb.CalculateReply>;

  divide(
    request: calculator_pb.CalculateRequest,
    metadata: grpcWeb.Metadata | null,
    callback?: (err: grpcWeb.RpcError,
               response: calculator_pb.CalculateReply) => void) {
    if (callback !== undefined) {
      return this.client_.rpcCall(
        this.hostname_ +
          '/calculator.CalculatorService/Divide',
        request,
        metadata || {},
        this.methodDescriptorDivide,
        callback);
    }
    return this.client_.unaryCall(
    this.hostname_ +
      '/calculator.CalculatorService/Divide',
    request,
    metadata || {},
    this.methodDescriptorDivide);
  }

}