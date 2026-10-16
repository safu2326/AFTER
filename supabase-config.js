/* AFTER Supabase public client configuration.
   This file may be committed to GitHub Pages because it contains only the publishable key.
   Never put a service_role / sb_secret key in frontend files. */
(function () {
  const SUPABASE_URL = 'https://hapzozitmgvnqvppbfga.supabase.co';
  const SUPABASE_PUBLISHABLE_KEY = 'sb_publishable_3qCTP9WA9e_8eRsB6_t7pQ_YO-IXVo-';
  if (window.supabase && window.supabase.createClient) {
    window.afterSupabase = window.supabase.createClient(
      SUPABASE_URL,
      SUPABASE_PUBLISHABLE_KEY
    );
  } else {
    console.error('Supabase JS library failed to load. Check your internet connection.');
  }
})();
