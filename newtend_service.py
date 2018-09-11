# -*- coding: utf-8 -*-

from datetime import datetime
from pytz import timezone
from iso8601 import parse_date
from op_robot_tests.tests_files.service_keywords import get_now
from calendar import monthrange
import urllib


def substract(dividend, divisor):
    return int(dividend) - int(divisor)


def download_file(url, file_name, output_dir):
    urllib.urlretrieve(url, ('{}/{}'.format(output_dir, file_name)))


def newtend_date_picker_index(isodate):
    now = get_now()
    date_str = '01' + str(now.month) + str(now.year)
    first_day_of_month = datetime.strptime(date_str, "%d%m%Y")
    mod = first_day_of_month.isoweekday() - 2
    iso_dt = parse_date(isodate)
    if now.day > iso_dt.day:
        mod = monthrange(now.year, now.month)[1] + mod
    return mod + iso_dt.day


def update_data_for_newtend(tender_data):
    tender_data.data.procuringEntity['name'] = u"Organizer trader"
    return tender_data


def update_data_for_newtend_new(role_name, tender_data):
    if role_name == 'tender_owner':
        tender_data['data']['assetCustodian']['identifier']['id'] = u"987987"
        tender_data['data']['assetCustodian']['identifier']['scheme'] = u"UA-EDR"
        tender_data['data']['assetCustodian']['identifier']['legalName'] = u"Privatizun test K"
        tender_data['data']['assetCustodian']['contactPoint']['name'] = u"Privatizun test K"
        tender_data['data']['assetCustodian']['contactPoint']['telephone'] = u"+380633959229"
        tender_data['data']['assetCustodian']['contactPoint']['email'] = u"newttest78+501@gmail.com"
    return tender_data


def convert_to_float(value):
    converted_float = float(value)
    return converted_float


# This works in code
def get_time_with_offset(date):
    date_obj = datetime.strptime(date, "%Y-%m-%d %H:%M:%S")
    time_zone = timezone('Europe/Kiev')
    localized_date = time_zone.localize(date_obj)
    return localized_date.strftime('%Y-%m-%d %H:%M:%S.%f%z')


def convert_newtend_auction_date_format(date_time_from_ui):
    new_time = datetime.strptime(date_time_from_ui, '%Y-%m-%d %H:%M:%S')
    return new_time.strftime('%Y-%m-%d %H:%M:%S')


def add_timezone_to_date(date_str):
    new_date = datetime.strptime(date_str, "%Y-%m-%d %H:%M:%S")
    time_zone = timezone('Europe/Kiev')
    localized_date = time_zone.localize(new_date)
    return localized_date.strftime("%Y-%m-%d %H:%M:%S%z")


def convert_newtend_date_to_iso_format(date_time_from_ui):
    new_timedata = datetime.strptime(date_time_from_ui, '%Y-%m-%d %H:%M:%S')
    return new_timedata.strftime("%Y-%m-%d %H:%M:%S")


def to_iso_date(date_from_ui):
    try:
        date_obj = datetime.strptime(date_from_ui, "%Y-%m-%d %H:%M:%S")
    except ValueError:
        date_obj = datetime.strptime(date_from_ui, "%Y-%m-%d %H:%M")
    time_zone = timezone('Europe/Kiev')
    localized_date = time_zone.localize(date_obj)
    just_time = localized_date.strftime('%Y-%m-%dT%H:%M:%S')
    time_zone = localized_date.strftime('%z')
    if len(time_zone) > 4:
        time_zone = time_zone[0:3] + ':' + time_zone[3:]
    return just_time + time_zone


def convert_nt_string_to_ssp_string(string):
    return {
        # assets statuses
        u'complete': u'об’єкт зареєстровано',
        u'registering': u'об’єкт реєструється',
        u'unknown': u'невідомо (не застосовується)',
        u'Опубліковано. Очікування інформаційного повідомлення.': u'pending',
        u'Опубліковано': u'pending',
        u'об’єкт зареєстровано': u'complete',
        u'Виключено з переліку': u'deleted',
        # lot statuses
        u"Інформація про оприлюднення інформаційного повідомлення": u"informationDetails",
        u'Об’єкт виключено': u'deleted',
        u'Аукціон': u'active.auction',
        # unit name
        u"square metre": u"метри квадратні",
        u"piece": u"штуки",
        u"метры квадратные": u"метри квадратні",
        u"": u"",

    }.get(string, string)


def convert_nt_string_to_common_string(string):
    return {
        # Our data: converts to CDB data assertion
        u"кілограми": u"кілограм",
        u"кг.": u"кілограми",
        u"грн.": u"UAH",
        u"c НДС": True,
        u"VAT incl.": True,
        u"Картонки": u"Картонні коробки",
        u"Уточнение": u"active.enquiries",
        u"Предложения": u"active.tendering",
        u"Пропозиції": u"active.tendering",
        u"Аукцион": u"active.auction",
        u"Аукціон": u"active.auction",
        u"Auction": u"active.auction",
        u'Кваліфікація': u'active.qualification',
        u'Qualification': u'active.qualification',
        u'Cancelled': u'cancelled',
        u'Скасовано': u'cancelled',
        u'Отменен': u'cancelled',
        u'Несостоявшийся': u'unsuccessful',
        u'Не відбувся': u'unsuccessful',
        u'Failed': u'unsuccessful',
        u'Considered': u'',
        u'active.awarded': u'active.qualification',
        u"Житлова нерухомість": u"Житлова  нерухомість",
        u'Auction cancelled': u'cancelled',
        u'Торги відмінено': u'cancelled',
        u'Торги отменены': u'cancelled',
        u'Lot cancelled': u'active',
        u'Лот скасовано': u'active',
        u'Completed': u'complete',
        u'Завершен': u'complete',
        u'Завершено': u'complete',
        u'До участі допускаються лише ліцензовані фінансові установи.': u'Only licensed financial institutions are eligible to participate.',
        u'К участию допускаются только лицензированные финансовые учреждения.': u'Only licensed financial institutions are eligible to participate.',
        u'Law requirements': u'dgfFinancialAssets',
        u'Права вимоги за кредитами': u'dgfFinancialAssets',
        u'Аукціон з оренди': u'dgfOtherAssets',  # new vision of life
        u'Майно банків': u'dgfOtherAssets',
        u'Assets of banks': u'dgfOtherAssets',
        u'Юридична Інформація Майданчиків': u'x_dgfPlatformLegalDetails',
        u'Очікує на рішення': u'pending.verification',
        u'Ожидает решения': u'pending.verification',
        u'Expecting decision': u'pending.verification',
        u'Очікує розгляду': u'pending.waiting',
        u'Ожидает рассмотрения': u'pending.waiting',
        u'Expecting consideration': u'pending.waiting',
        u'Очікується оплата': u'pending.payment',
        u'Ожидается оплата': u'pending.payment',
        u'Pending payment': u'pending.payment',
        u'Expecting payment': u'pending.payment',
        u'Очікує кінця кваліфікації першого учасника': u'pending.waiting',
        u'Ожидает квалификации конца первого участника': u'pending.waiting',
        u'Очікується завантаження та підтвердження протоколу': u'pending.verification',
        u'Ожидается загрузка и подтверждение протокола': u'pending.verification',
        u'A protocol download and confirmation is awaited': u'pending.verification',
        u'Відхилений': u'unsuccessful',
        u'Отклонен': u'unsuccessful',
        u'Refused': u'unsuccessful',
        u'Очікується підписання контракту': u'active',
        u'Ожидается подписание контракта': u'active',
        u'Expected the signing of the contract': u'active',
        u'Голландський аукціон': u'dgfInsider',
        u'Голандський аукціон': u'dgfInsider',
        u'Голландский аукцион': u'dgfInsider',
        u'Dutch': u'dgfInsider',
        u'CAV classificator': u'CPV',  # u'CAV-PS',   # CAV was previously
        u"Код відповідного класифікатору лоту": u"CPV",  # CAV was
        u"Код соответствующего классификатора лота": u"CPV",  # CAV was
        u"Додатковий класифікатор": u"PA01-7",  # PA01-7 was
        u"Lot cancelled": u"active",
        u"Лот отменен": u"active",
        u"Лот скасовано": u"active",
        u'VAT incl': True,
        u'з ПДВ': True,
        u'Used tractors': u'Трактори, що були у використанні',
        u'pending': u'Опубліковано. Очікування інформаційного повідомлення'
    }.get(string, string)


def get_index(value, add):
    index = int(value) + int(add)
    return str(index)


def adapt_name_field(name_field):
    return {
        'value.amount': 'value',
        'minimalStep.amount': 'minimal-step',
        'guarantee.amount': 'guarantee',
        'registrationFee.amount': 'registration-fee'
    }.get(name_field, name_field)
