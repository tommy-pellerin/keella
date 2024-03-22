import { Controller } from "stimulus"

export default class extends Controller {
  update(event) {
    let city_id = event.target.value
    let url = `/workouts?city_id=${city_id}`
    Turbo.visit(url, { action: 'replace' })
  }
}