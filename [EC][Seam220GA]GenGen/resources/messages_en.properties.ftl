<#import "*/gen-options.ftl" as opt>
<#assign entityName = tableName?replace("_", " ")?capitalize?replace(" ", "")>
Language_en=English
Language_es=Spanish

up=\u2191
down=\u2193
left=\u2039
right=\u203A

validator.assertFalse=validation failed
validator.assertTrue=validation failed
validator.future=must be a future date
validator.length=length must be between {min} and {max}
validator.max=must be less than or equal to {value}
validator.min=must be greater than or equal to {value}
validator.notNull=may not be null
validator.past=must be a past date
validator.pattern=must match "{regex}"
validator.range=must be between {min} and {max}
validator.size=size must be between {min} and {max}
validator.email=must be a well-formed email address

org.jboss.seam.loginFailed=Login failed
org.jboss.seam.loginSuccessful=Welcome, #0!

org.jboss.seam.TransactionFailed=Transaction failed
org.jboss.seam.NoConversation=The conversation ended, timed out or was processing another request
org.jboss.seam.IllegalNavigation=Illegal navigation
org.jboss.seam.ProcessEnded=Process #0 already ended
org.jboss.seam.ProcessNotFound=Process #0 not found
org.jboss.seam.TaskEnded=Task #0 already ended
org.jboss.seam.TaskNotFound=Task #0 not found
org.jboss.seam.NotLoggedIn=Please log in first

javax.faces.component.UIInput.CONVERSION=value could not be converted to the expected type
javax.faces.component.UIInput.REQUIRED=value is required
javax.faces.component.UIInput.UPDATE=an error occurred when processing your submitted information
javax.faces.component.UISelectOne.INVALID=value is not valid
javax.faces.component.UISelectMany.INVALID=value is not valid

javax.faces.converter.BigDecimalConverter.DECIMAL=value must be a number
javax.faces.converter.BigDecimalConverter.DECIMAL_detail=value must be a signed decimal number consisting of zero or more digits, optionally followed by a decimal point and fraction, eg. {1}
javax.faces.converter.BigIntegerConverter.BIGINTEGER=value must be an integer
javax.faces.converter.BigIntegerConverter.BIGINTEGER_detail=value must be a signed integer number consisting of zero or more digits
javax.faces.converter.BooleanConverter.BOOLEAN=value must be true or false
javax.faces.converter.BooleanConverter.BOOLEAN_detail=value must be true or false (any value other than true will evaluate to false)
javax.faces.converter.ByteConverter.BYTE=value must be a number between 0 and 255
javax.faces.converter.ByteConverter.BYTE_detail=value must be a number between 0 and 255
javax.faces.converter.CharacterConverter.CHARACTER=value must be a character
javax.faces.converter.CharacterConverter.CHARACTER_detail=value must be a valid ASCII character
javax.faces.converter.DateTimeConverter.DATE=value must be a date
javax.faces.converter.DateTimeConverter.DATE_detail=value must be a date,  eg. {1}
javax.faces.converter.DateTimeConverter.TIME=value must be a time
javax.faces.converter.DateTimeConverter.TIME_detail=value must be a time,  eg. {1}
javax.faces.converter.DateTimeConverter.DATETIME=value must be a date and time
javax.faces.converter.DateTimeConverter.DATETIME_detail=value must be a date and time,  eg. {1}
javax.faces.converter.DateTimeConverter.PATTERN_TYPE=a pattern or type attribute must be specified to convert the value
javax.faces.converter.DoubleConverter.DOUBLE=value must be a number
javax.faces.converter.DoubleConverter.DOUBLE_detail=value must be a number between 4.9E-324 and 1.7976931348623157E308
javax.faces.converter.EnumConverter.ENUM=value must be convertible to an enum
javax.faces.converter.EnumConverter.ENUM_detail=value must be convertible to an enum or from the enum that contains the constant {1}
javax.faces.converter.EnumConverter.ENUM_NO_CLASS=value must be convertible to an enum or from the enum, but no enum class provided
javax.faces.converter.EnumConverter.ENUM_NO_CLASS_detail=value must be convertible to an enum or from the enum, but no enum class provided
javax.faces.converter.FloatConverter.FLOAT=value must be a number
javax.faces.converter.FloatConverter.FLOAT_detail=value must be a number between 1.4E-45 and 3.4028235E38
javax.faces.converter.IntegerConverter.INTEGER=value must be an integer
javax.faces.converter.IntegerConverter.INTEGER_detail=value must be an integer number between -2147483648 and 2147483647
javax.faces.converter.LongConverter.LONG=value must be an integer
javax.faces.converter.LongConverter.LONG_detail=value must be an integer number between -9223372036854775808 and 9223372036854775807
javax.faces.converter.NumberConverter.CURRENCY=value must be a currency amount
javax.faces.converter.NumberConverter.CURRENCY_detail=value must be a currency amount, eg. {1}
javax.faces.converter.NumberConverter.PERCENT=value must be a percentage amount
javax.faces.converter.NumberConverter.PERCENT_detail=value must be a percentage amount, eg. {1}
javax.faces.converter.NumberConverter.NUMBER=value must be a number
javax.faces.converter.NumberConverter.NUMBER_detail=value must be a number
javax.faces.converter.NumberConverter.PATTERN=value must be a number
javax.faces.converter.NumberConverter.PATTERN_detail=value must be a number
javax.faces.converter.ShortConverter.SHORT=value must be an integer
javax.faces.converter.ShortConverter.SHORT_detail=value must be an integer number between -32768 and 32767

javax.faces.validator.DoubleRangeValidator.MAXIMUM=value must be less than or equal to {0}
javax.faces.validator.DoubleRangeValidator.MINIMUM=value must be greater than or equal to {0}
javax.faces.validator.DoubleRangeValidator.NOT_IN_RANGE=value must be between {0} and {1}
javax.faces.validator.DoubleRangeValidator.TYPE=value is not of the correct type
javax.faces.validator.LengthValidator.MAXIMUM=value must be shorter than or equal to {0} characters
javax.faces.validator.LengthValidator.MINIMUM=value must be longer than or equal to {0} characters
javax.faces.validator.LongRangeValidator.MAXIMUM=value must be less than or equal to {0}
javax.faces.validator.LongRangeValidator.MINIMUM=value must be greater than or equal to {0}
javax.faces.validator.LongRangeValidator.NOT_IN_RANGE=value must be between {0} and {1}
javax.faces.validator.LongRangeValidator.TYPE=value is not of the correct type

javax.faces.validator.NOT_IN_RANGE=value m ocurrido algo inseperadoust be between {0} and {1}
javax.faces.converter.STRING=value could not be converted to a string

#Mensajes de excepciones de Seam
seam_error_inesperado=Unexpected error, please try again
seam_view_expired_exception=Your session has timed out, please try again
seam_authorization_exception=You don't have permission to access this resource
seam_optimistic_lock_exception=Another user changed the same data, please try again
seam_entity_exists_exception=Duplicate record
seam_persistence_entity_not_found_exception=Record not found
seam_entity_not_found_exception=Record not found
no_borrar_exception=Cannot delete entity. Verify if is not related with to other entities and try again.

#Mensajes del MENU
home_link_label=Home
logout_link_label=Disconnect
login_link_label=Login
menuWelcome=signed in as: ${'#'}{credentials.username}
menu_new_ticket=New Ticket
menu_tickets=My Ticktes
menu_admin=Administrate
menu_queues=Queues
menu_groups=Groups
menu_greets=Salutations
menu_signatures=Signatures
menu_mail_addresses=Mail addresses
menu_states=States
menu_roles=Roles
menu_responses=Responses
menu_roles_grupos=Roles <-> Groups
menu_preferences=Preferences
menu_faqs_area=FAQS-Area
menu_respuestaaut_=Auto Responses
menu_tipo_respuestaaut_=Auto Responses Types
menu_tipo_respuesta_colas=Responses <-> Queues
menu_respuestaaut_cola=Auto Responses <-> Queues
menu_adjuntos=Attachments
menu_prioridad_=Priority
menu_anexos_respuestas=Attachments <-> Responses
menu_anexos_categoria_incidencias=Incident Categories
menu_configuraciones=Configurations
menu_Feriados=Holidays
menu_colas_grupos=Queues <-> Groups
menu_prioridad_superior=Superior Priority
menu_stats=Stats
menu_ayuda=Help
menu_instituciones=Institutions
ChangeLanguage=Change Language

${'#'}Internacionalizacion de RICH_FACES
RICH_CALENDAR_TODAY_LABEL=Today
RICH_CALENDAR_APPLY_LABEL=Apply
${'#'}RICH_CALENDAR_CLOSE_LABEL=Close
RICH_CALENDAR_OK_LABEL=Ok
RICH_CALENDAR_CLEAN_LABEL=Clean
RICH_CALENDAR_CANCEL_LABEL=Cancel

RICH_FILE_UPLOAD_CANCEL_LABEL=Cancel
RICH_FILE_UPLOAD_STOP_LABEL=Stop
RICH_FILE_UPLOAD_ADD_LABEL=Add
RICH_FILE_UPLOAD_UPLOAD_LABEL=Upload
RICH_FILE_UPLOAD_CLEAR_LABEL=Clear
RICH_FILE_UPLOAD_CLEAR_ALL_LABEL=Clear All
RICH_FILE_UPLOAD_PROGRESS_LABEL=Progress
RICH_FILE_UPLOAD_SIZE_ERROR_LABLE=Size Error
RICH_FILE_UPLOAD_TRANSFER_ERROR_LABLE=Transfer Error
RICH_FILE_UPLOAD_ENTRY_STOP_LABEL=Stop
RICH_FILE_UPLOAD_ENTRY_CLEAR_LABEL=Clear
RICH_FILE_UPLOAD_ENTRY_CANCEL_LABEL=Cancel
RICH_FILE_UPLOAD_ENTRY_DONE_LABEL=Done

RICH_PICK_LIST_COPY_ALL_LABEL=Copy all
RICH_PICK_LIST_COPY_LABEL=Copy
RICH_PICK_LIST_REMOVE_ALL_LABEL=Remove
RICH_PICK_LIST_REMOVE_LABEL=Remove all

${'#'}Mensajes GENERALES
wiwdow_browser_title=${opt.applicationTitle}
msg_usuario_invalido=Invalid user
msg_required_fields=required fields
msg_add_male=New
msg_add_female=New
msg_edit=Edit
msg_save=Save
msg_update=Save
msg_delete=Delete
msg_cancel=Cancel
msg_detail=Detalle
msg_create_male=New
msg_create_female=New
msg_filter_match=Match
msg_filter_match_All=All
msg_filter_match_Any=Any
msg_list_search_filter=Search Filter
msg_list_search_results=Search Results
msg_list_search_no_results=Search returned no results.
msg_list_search_button=Search
msg_list_search_reset_button=Reset
msg_list_search_print_button=Print
msg_list_action_column=Action
msg_list_view=View
msg_list_select=Select
msg_list_back=Back
msg_list_first_page=First Page
msg_list_previous_page=Previous Page
msg_list_next_page=Next Page
msg_list_last_page=Last Page
msg_change=Change
msg_select=Select
msg_done=Done
msg_confirm_delete=Are you sure you want to delete the record?
msg_confirm_update=Are you sure you want to update the record?
msg_no_se_pudo_fusionar_exception=Cannot merge the tickets
msg_no_se_pudo_enviar_correo=WARNING: Notification mail not be sended.
msg_correo_enviado=Mail has been sended.

#Mensajes por vistas Ej.: /FooList.xhtml

#/home.xhtml
home_welcome_header=${opt.applicationTitle}
home_please_login_message=Select an option from the menu.

#/login.xhtml
login_panel_header=Login
login_panel_message=Please login here
login_panel_dialog_username=Username
login_panel_dialog_password=Password
login_panel_dialog_remember_me=Remember me
login_panel_login_button=Login

#Mensajes por Entidades

<#list tables as t>
  <#assign entityName = t.tableName?replace("_", " ")?capitalize?replace(" ", "")>
#${entityName}.java
${entityName}_=${t.tableName?replace("_", " ")?capitalize}
	<#foreach column in t.columns>
		<#assign msgGenerated = false />
		<#assign fk = opt.getFkFromTable(t,column) />
		<#if (fk?size > 0)>
			<#list tables as t1>
				<#if t1.tableName == fk.pktableName>
${entityName}_${opt.mixedCase(column)}=${fk.pktableName?replace("_", " ")?capitalize}
					<#assign msgGenerated = true />
				</#if>
			</#list>
		</#if>
		<#if !msgGenerated>
${entityName}_${opt.mixedCase(column)}=${column.columnName?replace("_", " ")?capitalize}
		</#if>
	</#foreach>
${entityName}_created=${t.tableName?replace("_", " ")?capitalize} created successfully
${entityName}_updated=${t.tableName?replace("_", " ")?capitalize} edited successfully
${entityName}_deleted=${t.tableName?replace("_", " ")?capitalize} deleted successfully
</#list>