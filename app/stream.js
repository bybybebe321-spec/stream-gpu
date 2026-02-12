const { chromium } = require("playwright-core");

const URL = process.env.PLAYER_URL;

(async () => {
  const browser = await chromium.launch({
    headless: false,
    executablePath: "/usr/bin/chromium-browser",
    args: ["--no-sandbox", "--window-size=1920,1080"]
  });

  const page = await browser.newPage();
  await page.goto(URL || "https://example.com");

  await page.waitForTimeout(7200000); // 2 часа

  await browser.close();
  process.exit(0);
})();
