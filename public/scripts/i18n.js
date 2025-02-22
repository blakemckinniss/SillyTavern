import { waitUntilCondition } from "./utils.js";

const storageKey = "language";
export const localeData = await fetch("i18n.json").then(response => response.json());

export function applyLocale(root = document) {
    const overrideLanguage = localStorage.getItem("language");
    var language = overrideLanguage || navigator.language || navigator.userLanguage;
    language = language.toLowerCase();
    //load the appropriate language file
    if (localeData.lang.indexOf(language) < 0) language = "en";

    const $root = root instanceof Document ? $(root) : $(new DOMParser().parseFromString(root, "text/html"));

    //find all the elements with `data-i18n` attribute
    $root.find("[data-i18n]").each(function () {
        //read the translation from the language data
        const keys = $(this).data("i18n").split(';'); // Multi-key entries are ; delimited
        for (const key of keys) {
            const attributeMatch = key.match(/\[(\S+)\](.+)/); // [attribute]key
            if (attributeMatch) { // attribute-tagged key
                const localizedValue = localeData?.[language]?.[attributeMatch[2]];
                if (localizedValue) {
                    $(this).attr(attributeMatch[1], localizedValue);
                }
            } else { // No attribute tag, treat as 'text'
                const localizedValue = localeData?.[language]?.[key];
                if (localizedValue) {
                    $(this).text(localizedValue);
                }
            }
        }
    });

    if (root !== document) {
        return $root.get(0).body.innerHTML;
    }
}

function addLanguagesToDropdown() {
    if (!Array.isArray(localeData?.lang)) {
        return;
    }

    for (const lang of localeData.lang) {
        const option = document.createElement('option');
        option.value = lang;
        option.innerText = lang;
        $('#ui_language_select').append(option);
    }

    const selectedLanguage = localStorage.getItem(storageKey);
    if (selectedLanguage) {
        $('#ui_language_select').val(selectedLanguage);
    }
}

jQuery(async () => {
    waitUntilCondition(() => !!localeData);
    window["applyLocale"] = applyLocale;
    applyLocale();
    addLanguagesToDropdown();

    $('#ui_language_select').on('change', async function () {
        const language = String($(this).val());

        if (language) {
            localStorage.setItem(storageKey, language);
        } else {
            localStorage.removeItem(storageKey);
        }

        location.reload();
    });
});
