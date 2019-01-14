---
title: Test feedback
layout: en

---

<form name="was_it_helpful" method="POST" data-netlify="true">

<div>
  <input type="radio" id="yes" name="helpful" value="yes">
  <label for="yes">Yes</label>
</div>

<div>
  <input type="radio" id="no" name="helpful" value="yes">
  <label for="no">No</label>
</div>

<input type="hidden" value="{{page.path}}" />

  <p>
    <label>Message: <textarea name="message"></textarea></label>
  </p>
  <p>
    <button type="submit">Send</button>
  </p>
</form>
