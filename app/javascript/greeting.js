document.addEventListener("DOMContentLoaded", function () {
  const button = document.getElementById("add_greeting");
  const textarea = document.getElementById("plane_mail_body");
  alert("Hello, world!1");
  if (button && textarea) {
    alert("Hello, world!2");
    button.addEventListener("click", function () {
      const now = new Date();
      const month = now.getMonth() + 1;
      let greeting = "";

      if ([3, 4, 5].includes(month)) {
        greeting = "春の陽気が心地よい季節となりました。";
      } else if ([6, 7, 8].includes(month)) {
        greeting = "暑さ厳しき折、どうぞご自愛ください。";
      } else if ([9, 10, 11].includes(month)) {
        greeting = "秋の深まりを感じる今日この頃です。";
      } else {
        greeting = "寒さ厳しき折、くれぐれもご自愛ください。";
      }
      textarea.value += (textarea.value ? "\n\n" : "") + greeting;
    });
  }
});