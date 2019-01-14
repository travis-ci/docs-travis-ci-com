---
title: Test feedback
layout: en

---

<form name="was_it_helpful" method="POST" data-netlify="true" netlify-honeypot="bot-field" data-netlify-recapture="false">

<p class="hidden">
    <label>Don’t fill this out if you're human: <input name="bot-field" /></label>
  </p>

<div>
  <input type="radio" id="yes" name="helpful" value="yes">
  <label for="yes">Yes</label>
</div>

<div>
  <input type="radio" id="no" name="helpful" value="yes">
  <label for="no">No</label>
</div>

<input type="hidden" name="path" value="{{page.path}}" />

  <p>
    <label>Message: <textarea name="message"></textarea></label>
  </p>
  <p>
    <button type="submit">Send</button>
  </p>
</form>
