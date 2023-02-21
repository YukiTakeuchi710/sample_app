import { Controller  } from "@hotwired/stimulus"

// Connects to data-controller="like"
export default class extends Controller {
  static targets = ["name"]
  like() {
    const element = this.nameTarget
    const name = element.value
    console.log(`Hello, ${name}!`)
  }
}
