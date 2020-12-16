const filterByIndicator = () => {
  const indicatorTable = document.querySelector(".table");
  const indicatorDropDown = document.getElementById("value_indicator_id");

  if (indicatorTable && indicatorDropDown) {
      indicatorDropDown.addEventListener("change", (event) => {
        indicatorTable.querySelectorAll("tr").forEach((tr) => {
          if (tr.classList.contains(indicatorDropDown.value))  {
            tr.style.display = "block"
          } else {
            tr.style.display = "none"
          }
        })
      })
  }
};

export {filterByIndicator}

