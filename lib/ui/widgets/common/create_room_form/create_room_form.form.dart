// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedFormGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, constant_identifier_names, non_constant_identifier_names,unnecessary_this

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

const bool _autoTextFieldValidation = true;

const String RoomNameValueKey = 'roomName';
const String UserNameValueKey = 'userName';

final Map<String, TextEditingController> _CreateRoomFormTextEditingControllers =
    {};

final Map<String, FocusNode> _CreateRoomFormFocusNodes = {};

final Map<String, String? Function(String?)?> _CreateRoomFormTextValidations = {
  RoomNameValueKey: null,
  UserNameValueKey: null,
};

mixin $CreateRoomForm {
  TextEditingController get roomNameController =>
      _getFormTextEditingController(RoomNameValueKey);
  TextEditingController get userNameController =>
      _getFormTextEditingController(UserNameValueKey);

  FocusNode get roomNameFocusNode => _getFormFocusNode(RoomNameValueKey);
  FocusNode get userNameFocusNode => _getFormFocusNode(UserNameValueKey);

  TextEditingController _getFormTextEditingController(
    String key, {
    String? initialValue,
  }) {
    if (_CreateRoomFormTextEditingControllers.containsKey(key)) {
      return _CreateRoomFormTextEditingControllers[key]!;
    }

    _CreateRoomFormTextEditingControllers[key] =
        TextEditingController(text: initialValue);
    return _CreateRoomFormTextEditingControllers[key]!;
  }

  FocusNode _getFormFocusNode(String key) {
    if (_CreateRoomFormFocusNodes.containsKey(key)) {
      return _CreateRoomFormFocusNodes[key]!;
    }
    _CreateRoomFormFocusNodes[key] = FocusNode();
    return _CreateRoomFormFocusNodes[key]!;
  }

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  void syncFormWithViewModel(FormStateHelper model) {
    roomNameController.addListener(() => _updateFormData(model));
    userNameController.addListener(() => _updateFormData(model));

    _updateFormData(model, forceValidate: _autoTextFieldValidation);
  }

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  @Deprecated(
    'Use syncFormWithViewModel instead.'
    'This feature was deprecated after 3.1.0.',
  )
  void listenToFormUpdated(FormViewModel model) {
    roomNameController.addListener(() => _updateFormData(model));
    userNameController.addListener(() => _updateFormData(model));

    _updateFormData(model, forceValidate: _autoTextFieldValidation);
  }

  /// Updates the formData on the FormViewModel
  void _updateFormData(FormStateHelper model, {bool forceValidate = false}) {
    model.setData(
      model.formValueMap
        ..addAll({
          RoomNameValueKey: roomNameController.text,
          UserNameValueKey: userNameController.text,
        }),
    );

    if (_autoTextFieldValidation || forceValidate) {
      updateValidationData(model);
    }
  }

  bool validateFormFields(FormViewModel model) {
    _updateFormData(model, forceValidate: true);
    return model.isFormValid;
  }

  /// Calls dispose on all the generated controllers and focus nodes
  void disposeForm() {
    // The dispose function for a TextEditingController sets all listeners to null

    for (var controller in _CreateRoomFormTextEditingControllers.values) {
      controller.dispose();
    }
    for (var focusNode in _CreateRoomFormFocusNodes.values) {
      focusNode.dispose();
    }

    _CreateRoomFormTextEditingControllers.clear();
    _CreateRoomFormFocusNodes.clear();
  }
}

extension ValueProperties on FormStateHelper {
  bool get hasAnyValidationMessage => this
      .fieldsValidationMessages
      .values
      .any((validation) => validation != null);

  bool get isFormValid {
    if (!_autoTextFieldValidation) this.validateForm();

    return !hasAnyValidationMessage;
  }

  String? get roomNameValue => this.formValueMap[RoomNameValueKey] as String?;
  String? get userNameValue => this.formValueMap[UserNameValueKey] as String?;

  set roomNameValue(String? value) {
    this.setData(
      this.formValueMap..addAll({RoomNameValueKey: value}),
    );

    if (_CreateRoomFormTextEditingControllers.containsKey(RoomNameValueKey)) {
      _CreateRoomFormTextEditingControllers[RoomNameValueKey]?.text =
          value ?? '';
    }
  }

  set userNameValue(String? value) {
    this.setData(
      this.formValueMap..addAll({UserNameValueKey: value}),
    );

    if (_CreateRoomFormTextEditingControllers.containsKey(UserNameValueKey)) {
      _CreateRoomFormTextEditingControllers[UserNameValueKey]?.text =
          value ?? '';
    }
  }

  bool get hasRoomName =>
      this.formValueMap.containsKey(RoomNameValueKey) &&
      (roomNameValue?.isNotEmpty ?? false);
  bool get hasUserName =>
      this.formValueMap.containsKey(UserNameValueKey) &&
      (userNameValue?.isNotEmpty ?? false);

  bool get hasRoomNameValidationMessage =>
      this.fieldsValidationMessages[RoomNameValueKey]?.isNotEmpty ?? false;
  bool get hasUserNameValidationMessage =>
      this.fieldsValidationMessages[UserNameValueKey]?.isNotEmpty ?? false;

  String? get roomNameValidationMessage =>
      this.fieldsValidationMessages[RoomNameValueKey];
  String? get userNameValidationMessage =>
      this.fieldsValidationMessages[UserNameValueKey];
}

extension Methods on FormStateHelper {
  setRoomNameValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[RoomNameValueKey] = validationMessage;
  setUserNameValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[UserNameValueKey] = validationMessage;

  /// Clears text input fields on the Form
  void clearForm() {
    roomNameValue = '';
    userNameValue = '';
  }

  /// Validates text input fields on the Form
  void validateForm() {
    this.setValidationMessages({
      RoomNameValueKey: getValidationMessage(RoomNameValueKey),
      UserNameValueKey: getValidationMessage(UserNameValueKey),
    });
  }
}

/// Returns the validation message for the given key
String? getValidationMessage(String key) {
  final validatorForKey = _CreateRoomFormTextValidations[key];
  if (validatorForKey == null) return null;

  String? validationMessageForKey = validatorForKey(
    _CreateRoomFormTextEditingControllers[key]!.text,
  );

  return validationMessageForKey;
}

/// Updates the fieldsValidationMessages on the FormViewModel
void updateValidationData(FormStateHelper model) =>
    model.setValidationMessages({
      RoomNameValueKey: getValidationMessage(RoomNameValueKey),
      UserNameValueKey: getValidationMessage(UserNameValueKey),
    });
