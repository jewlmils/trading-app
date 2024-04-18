import "@fortawesome/fontawesome-free";
import "@hotwired/turbo-rails";
import "controllers";

document.addEventListener("turbolinks:load", function () {
  const dropdownToggle = document.querySelector(
    '[data-toggle-dropdown="dropdownNavbar"]'
  );
  const dropdownMenu = document.getElementById("dropdownNavbar");

  if (dropdownToggle && dropdownMenu) {
    dropdownToggle.addEventListener("click", function () {
      dropdownMenu.classList.toggle("hidden");
    });

    document.addEventListener("click", function (event) {
      if (
        !dropdownToggle.contains(event.target) &&
        !dropdownMenu.contains(event.target)
      ) {
        dropdownMenu.classList.add("hidden");
      }
    });
  }
});
