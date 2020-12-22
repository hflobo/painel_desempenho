const filterByIndicatorValue = () => {
  const indicatorTable = document.querySelector(".table");
  const indicatorDropDown = document.getElementById("value_indicator_id");

  if (indicatorTable && indicatorDropDown) {
      indicatorDropDown.addEventListener("change", (event) => {
        indicatorTable.querySelectorAll("tr").forEach((tr) => {
          if (tr.classList.contains(indicatorDropDown.value) || tr.classList.contains("titulo")) {
            tr.style.display = ""
          } else {
            tr.style.display = "none"
          }
        })
      })
  }
};

export {filterByIndicatorValue};

const filterByIndicatorGoal = () => {
  const indicatorTable = document.querySelector(".table");
  const indicatorDropDown = document.getElementById("goal_indicator_id");

  if (indicatorTable && indicatorDropDown) {
      indicatorDropDown.addEventListener("change", (event) => {
        indicatorTable.querySelectorAll("tr").forEach((tr) => {
          if (tr.classList.contains(indicatorDropDown.value) || tr.classList.contains("titulo"))  {
            tr.style.display = ""
          } else {
            tr.style.display = "none"
          }
        })
      })
  }
};

export {filterByIndicatorGoal}

