# ترمه احمدیان - نسخه آزمایشی اندروید

پروژه Flutter آزمایشی، بدون درگاه پرداخت یا سفارش واقعی. قیمت‌ها و محصولات نمونه‌اند.

## ساخت با Codemagic
1. فایل‌های `pubspec.yaml` و `codemagic.yaml` و پوشه `lib/main.dart` را در یک مخزن GitHub قرار دهید.
2. در Codemagic مخزن را انتخاب کنید.
3. Workflow با نام `android-demo` را اجرا کنید.
4. پس از موفقیت ساخت، فایل APK را از بخش Artifacts دریافت کنید.

Codemagic هنگام ساخت، پوشه Android را با دستور `flutter create` تولید می‌کند.
