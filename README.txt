AFTER — responsive landing page

FILES
- index.html: main homepage
- styles.css: layout, styling, responsive design and animations
- script.js: mobile navigation interactions
- assets/hero-visual.jpg: visual cropped from the supplied reference image
- shop.html, categories.html, blog.html, about.html, search.html, account.html, cart.html: linked placeholder pages for future development

HOW TO PREVIEW
1. Extract after-website.zip (if using the ZIP).
2. Open the folder.
3. Double-click index.html to preview in a modern browser.

NOTES
- Shop and Shop Now both lead to shop.html.
- The logo and Home lead to index.html.
- Navigation and header action icons lead to their own placeholder pages.
- Google Fonts are used for a close visual match; a serif and sans-serif system fallback is included.
- This is a static front-end starter. Cart checkout, account login, search results and product management need backend/e-commerce integration later.


SHOP SETTINGS CLOUD
Run supabase-shop-settings.sql in Supabase SQL Editor. Then use Admin > Customer Inbox to sign in with Supabase Auth, ensure the user UUID is in public.admin_users, open Admin > Shop Settings, Load Cloud Settings, edit and Save Shop Settings to Cloud.

SHOP SETTINGS IMAGE UPLOAD: Run supabase-shop-settings.sql in Supabase SQL Editor (re-running is safe). The SQL also creates the public shop-assets Storage bucket and admin-only upload policy. In Admin > Shop Settings, choose UPLOAD HERO IMAGE or UPLOAD STORY IMAGE, select an image from your device, then click SAVE SHOP SETTINGS TO CLOUD.


SUPABASE CONTENT / REVIEWS UPDATE (2026-10)
1. Back up your current project before replacing files.
2. In Supabase Dashboard > SQL Editor, run SUPABASE-CONTENT-REVIEWS-CATEGORIES-ABOUT-BLOG.sql. It is additive and designed to be rerunnable; it does not drop existing shop tables.
3. The admin must be signed in using the Supabase Auth account already authorized in public.admin_users. The website's local admin login alone is not sufficient for cloud writes.
4. Product reviews are saved as pending and are not public until approved in Admin > Reviews & Ratings.
5. Delivery, About, Blog and category edits save to Supabase only after a successful cloud save; an error toast means the change stayed local.
6. Image uploads use the public categories, blog and about Storage buckets; each upload is limited to 8 MB and image file types.
7. Test one review, one category edit, one About edit, one Blog edit and delivery total on a staging/test order before relying on the live store. Never add a service-role key to frontend files.


PRODUCT CATEGORIES FEATURE
For customizable categories inside Admin > Products, run SUPABASE-PRODUCT-CATEGORIES.sql and follow SUPABASE-PRODUCT-CATEGORIES-BN.txt. This feature is separate from storefront display categories.


NEW IN THIS ZIP — RESPONSIVE HOME PAGE CONTROLS
- Admin > Home Page now has separate Mobile, Tablet/iPad and PC hero image/text settings.
- Mobile fallback image: assets/hero-mobile.jpg. Desktop fallback remains assets/hero-visual.jpg.
- Run SUPABASE-HOME-PAGE-CONTROL.sql in Supabase SQL Editor before using cloud upload/save.
- Bengali setup steps: SUPABASE-HOME-PAGE-CONTROL-BN.txt
- Existing website data files were retained; the new settings are stored as an additive key in shop_settings.settings.
