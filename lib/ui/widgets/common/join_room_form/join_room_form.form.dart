// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedFormGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, constant_identifier_names, non_constant_identifier_names,unnecessary_this

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

const bool _autoTextFieldValidation = true;

const String JoinCodeValueKey = 'joinCode';
const String UserNameValueKey = 'userName';

final Map<String, TextEditingController> _JoinRoomFormTextEditingControllers =
    {};

final Map<String, FocusNode> _JoinRoomFormFocusNodes = {};

final Map<String, String? Function(String?)?> _JoinRoomFormTextValidations = {
  JoinCodeValueKey: null,
  UserNameValueKey: null,
};

mixin $JoinRoomForm {
  TextEditingController get joinCodeController =>
      _getFormTextEditingController(JoinCodeValueKey);
  TextEditingController get userNameController =>
      _getFormTextEditingController(UserNameValueKey);

  FocusNode get joinCodeFocusNode => _getFormFocusNode(JoinCodeValueKey);
  FocusNode get userNameFocusNode => _getFormFocusNode(UserNameValueKey);

  TextEditingController _getFormTextEditingController(
    String key, {
    String? initialValue,
  }) {
    if (_JoinRoomFormTextEditingControllers.containsKey(key)) {
      return _JoinRoomFormTextEditingControllers[key]!;
    }

    _JoinRoomFormTextEditingControllers[key] =
        TextEditingController(text: initialValue);
    return _JoinRoomFormTextEditingControllers[key]!;
  }

  FocusNode _getFormFocusNode(String key) {
    if (_JoinRoomFormFocusNodes.containsKey(key)) {
      return _JoinRoomFormFocusNodes[key]!;
    }
    _JoinRoomFormFocusNodes[key] = FocusNode();
    return _JoinRoomFormFocusNodes[key]!;
  }

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  void syncFormWithViewModel(FormStateHelper model) {
    joinCodeController.addListener(() => _updateFormData(model));
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
    joinCodeController.addListener(() => _updateFormData(model));
    userNameController.addListener(() => _updateFormData(model));

    _updateFormData(model, forceValidate: _autoTextFieldValidation);
  }

  /// Updates the formData on the FormViewModel
  void _updateFormData(FormStateHelper model, {bool forceValidate = false}) {
    model.setData(
      model.formValueMap
        ..addAll({
          JoinCodeValueKey: joinCodeController.text,
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

    for (var controller in _JoinRoomFormTextEditingControllers.values) {
      controller.dispose();
    }
    for (var focusNode in _JoinRoomFormFocusNodes.values) {
      focusNode.dispose();
    }

    _JoinRoomFormTextEditingControllers.clear();
    _JoinRoomFormFocusNodes.clear();
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

  String? get joinCodeValue => this.formValueMap[JoinCodeValueKey] as String?;
  String? get userNameValue => this.formValueMap[UserNameValueKey] as String?;

  set joinCodeValue(String? value) {
    this.setData(
      this.formValueMap..addAll({JoinCodeValueKey: value}),
    );

    if (_JoinRoomFormTextEditingControllers.containsKey(JoinCodeValueKey)) {
      _JoinRoomFormTextEditingControllers[JoinCodeValueKey]?.text = value ?? '';
    }
  }

  set userNameValue(String? value) {
    this.setData(
      this.formValueMap..addAll({UserNameValueKey: value}),
    );

    if (_JoinRoomFormTextEditingControllers.containsKey(UserNameValueKey)) {
      _JoinRoomFormTextEditingControllers[UserNameValueKey]?.text = value ?? '';
    }
  }

  bool get hasJoinCode =>
      this.formValueMap.containsKey(JoinCodeValueKey) &&
      (joinCodeValue?.isNotEmpty ?? false);
  bool get hasUserName =>
      this.formValueMap.containsKey(UserNameValueKey) &&
      (userNameValue?.isNotEmpty ?? false);

  bool get hasJoinCodeValidationMessage =>
      this.fieldsValidationMessages[JoinCodeValueKey]?.isNotEmpty ?? false;
  bool get hasUserNameValidationMessage =>
      this.fieldsValidationMessages[UserNameValueKey]?.isNotEmpty ?? false;

  String? get joinCodeValidationMessage =>
      this.fieldsValidationMessages[JoinCodeValueKey];
  String? get userNameValidationMessage =>
      this.fieldsValidationMessages[UserNameValueKey];
}

extension Methods on FormStateHelper {
  setJoinCodeValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[JoinCodeValueKey] = validationMessage;
  setUserNameValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[UserNameValueKey] = validationMessage;

  /// Clears text input fields on the Form
  void clearForm() {
    joinCodeValue = '';
    userNameValue = '';
  }

  /// Validates text input fields on the Form
  void validateForm() {
    this.setValidationMessages({
      JoinCodeValueKey: getValidationMessage(JoinCodeValueKey),
      UserNameValueKey: getValidationMessage(UserNameValueKey),
    });
  }
}

/// Returns the validation message for the given key
String? getValidationMessage(String key) {
  final validatorForKey = _JoinRoomFormTextValidations[key];
  if (validatorForKey == null) return null;

  String? validationMessageForKey = validatorForKey(
    _JoinRoomFormTextEditingControllers[key]!.text,
  );

  return validationMessageForKey;
}

/// Updates the fieldsValidationMessages on the FormViewModel
void updateValidationData(FormStateHelper model) =>
    model.setValidationMessages({
      JoinCodeValueKey: getValidationMessage(JoinCodeValueKey),
      UserNameValueKey: getValidationMessage(UserNameValueKey),
    });
