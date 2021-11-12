import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["answer", "page"]
  toggle(e) {
    e.preventDefault();
    this.answerTargets.forEach((item) => {
    if (item == e.currentTarget) {
			e.currentTarget.classList.toggle('selected');
      e.currentTarget.firstElementChild.classList.toggle('selected')
		} else if (item !== e.currentTarget.firstElementChild) {
      item.classList.remove('selected')
      item.firstElementChild.classList.remove('selected')
		}
		});
  }
  next(e) {
    e.preventDefault();
    if (e.currentTarget.id == "first-next") {
      document.getElementById('quiz-page-2').scrollIntoView();
    } else if (e.currentTarget.id == "second-next") {
      document.getElementById('quiz-page-3').scrollIntoView();
    }
  }

  previous(e) {
    e.preventDefault();
    if (e.currentTarget.id == "first-previous") {
      document.getElementById('quiz-page-1').scrollIntoView();
    } else if (e.currentTarget.id == "second-previous") {
      document.getElementById('quiz-page-2').scrollIntoView();
    }
  }

  finish(e) {
    e.preventDefault();
    document.getElementById('quiz-results').scrollIntoView();
    // remove d-none from chosen
    let first = document.getElementsByClassName('selected')[1].textContent
    let second = document.getElementsByClassName('selected')[3].textContent
    let third = document.getElementsByClassName('selected')[5].textContent
    document.getElementById(`first-${first}`).classList.remove('d-none')
    document.getElementById(`second-${second}`).classList.remove('d-none');
    document.getElementById(`third-${third}`).classList.remove('d-none');
    console.log(second)
  }
}
