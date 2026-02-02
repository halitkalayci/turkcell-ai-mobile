package com.turkcell.aimobile.exception;

import com.turkcell.aimobile.dto.ErrorResponse;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.time.Instant;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ErrorResponse> handleValidationException(MethodArgumentNotValidException ex) {
        List<String> details = ex.getBindingResult().getAllErrors().stream()
                .map(error -> {
                    String fieldName = ((FieldError) error).getField();
                    String message = error.getDefaultMessage();
                    return fieldName + ": " + message;
                })
                .collect(Collectors.toList());

        ErrorResponse errorResponse = new ErrorResponse();
        errorResponse.setCode("VALIDATION_ERROR");
        errorResponse.setMessage("Validation failed.");
        errorResponse.setDetails(details);
        errorResponse.setCorrelationId(UUID.randomUUID().toString());
        errorResponse.setTimestamp(Instant.now());

        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(errorResponse);
    }

    @ExceptionHandler(ProductNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleProductNotFoundException(ProductNotFoundException ex) {
        ErrorResponse errorResponse = new ErrorResponse();
        errorResponse.setCode("NOT_FOUND");
        errorResponse.setMessage(ex.getMessage());
        errorResponse.setDetails(List.of());
        errorResponse.setCorrelationId(UUID.randomUUID().toString());
        errorResponse.setTimestamp(Instant.now());

        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(errorResponse);
    }

    @ExceptionHandler(ConflictException.class)
    public ResponseEntity<ErrorResponse> handleConflictException(ConflictException ex) {
        ErrorResponse errorResponse = new ErrorResponse();
        String code = ex.getMessage();
        errorResponse.setCode(code);
        if ("PRODUCT_NAME_ALREADY_EXISTS".equals(code)) {
            errorResponse.setMessage("Product name already exists.");
        } else if ("SKU_ALREADY_EXISTS".equals(code)) {
            errorResponse.setMessage("SKU already exists.");
        } else {
            errorResponse.setMessage("Conflict.");
        }
        errorResponse.setDetails(List.of());
        errorResponse.setCorrelationId(UUID.randomUUID().toString());
        errorResponse.setTimestamp(Instant.now());

        return ResponseEntity.status(HttpStatus.CONFLICT).body(errorResponse);
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorResponse> handleGenericException(Exception ex) {
        ErrorResponse errorResponse = new ErrorResponse();
        errorResponse.setCode("INTERNAL_ERROR");
        errorResponse.setMessage("Unexpected error occurred.");
        errorResponse.setDetails(List.of());
        errorResponse.setCorrelationId(UUID.randomUUID().toString());
        errorResponse.setTimestamp(Instant.now());

        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
    }
}
