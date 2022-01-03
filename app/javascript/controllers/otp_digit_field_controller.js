import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = ['mainField']
  static values = {
    codeLength: String
  }

  checkAllowance(e) {
    if (!this._isValidOtpField(e.key)) {
      e.preventDefault();
    }
  }

  handleInputEvent(e) {
    const digitValue = e.data
    if (digitValue == null) { return; }

    if(('0' <= digitValue && digitValue <= '9') || ('a' <= digitValue && digitValue <= 'z')) {
      const next = this.element.querySelector(`input#${e.currentTarget.dataset.next}`)

      if(next !== null) {
        next.focus()
      }
    }

    this._updateMainField()
  }

  handleKeyUp(e) {
    if(e.key === 'Backspace' || e.key === 'ArrowLeft') {
      const prev = this.element.querySelector(`input#${e.currentTarget.dataset.previous}`)

      if(prev !== null) {
        prev.focus()
      }
    } else if(e.key === 'ArrowRight') {
      const next = this.element.querySelector(`input#${e.currentTarget.dataset.next}`)

      if(next !== null) {
        next.focus()
      }
    } else if(e.key === 'Enter' && this._allFieldsAreFilled()) {
      this.mainFieldTarget.form.submit()
    }
  }

  _updateMainField() {
    let otpCode = ''
    for (var i = 1; i < (Number(this.codeLengthValue) + 1); i += 1) {
      otpCode += this.element.querySelector(`input#digit-${i}`).value
    }

    this.mainFieldTarget.value = otpCode
  }

  _isValidOtpField(key) {
    return (key === 'Backspace') ||
            (key === 'ArrowLeft') ||
            (key === 'ArrowRight') ||
            ('0' <= key && key <= '9') ||
            ('a' <= key && key <= 'z');
  }

  _allFieldsAreFilled() {
    return this.mainFieldTarget.value.length === Number(this.codeLengthValue)
  }

}
