# Talking to your data

So you've got a database, and you want to talk to it.  Here I will show you how you can talk to the database of all Norwegian organizations (companies ++) in plain English and plain Norwegian.

You do not need to be a data sientist, database guru or a programmer to do this. You just need to be able to read and write.

You can do this yourself on your own computer, or you can just read along to see what the AI ChatGPT can do.

If you want to do it on your own computer, you go to the [shadow-brreg repository](https://github.com/terchris/shadow-brreg) and follow the instructions there.


## The questions you can ask

Here are some questions you can ask ChatGPT. You can ask it in plain English or plain Norwegian. You can also ask it in a mix of English and Norwegian. ChatGPT will understand you. Here I write the full answer from ChatGPT.

I have marked my questions:
>like this

And ChatGPT's answers:
*ChatGPT: like this*

Here are some questions you can ask ChatGPT:

1. Finding a organisation by organisasjonsnummer

    >What is the name of the organisation with organisasjonsnummer 987654321?

    *ChatGPT: To find the name of the organisation with the organisasjonsnummer 987654321, you would use the following SQL statement:*

    ```sql
    SELECT navn FROM brreg_enheter_alle WHERE organisasjonsnummer='987654321'
    ```

    *ChatGPT: This statement selects the 'navn' column from the table 'brreg_enheter_alle' where the 'organisasjonsnummer' column is equal to '987654321'. It will return the name of the organisation with the specified organisasjonsnummer.*

2. Who has the most employees?

    >Witch organisation has the most employees?

    *ChatGPT:To find the organization with the most employees, you can use the following SQL query:* 

    ```sql
    SELECT navn, antall_ansatte
    FROM brreg_enheter_alle
    ORDER BY antall_ansatte DESC
    LIMIT 1
    ```

    *ChatGPT:This query selects the `navn` and `antall_ansatte` columns from the `brreg_enheter_alle` table, orders the rows by the number of employees in descending order, and returns only the top result.*

As you see ChatGPT even explains the SQL statements it gives you. It is a very good teacher. In order for ChatGPT to understand what data you have you need to tell it about the data structure and fields.
See below in the section "Tell ChatGPT what your data looks like" for how to do that.


## Future questions to the Urbalurba database

I'm writing a program that will sync data from the brreg database into a database that has lots of more information about the companies. That system is called Urbalurba and will be able to answer questions like this:

>Display on a map the 10 companies that has more than a 1000 employees or a turnover of more than 1 billion and focus on Sustainabe development goal number 11.

>What public tenders are out that my company can apply to?

>Companies simmilar to my company that focus on Sustainabe development goal number 11.

To be able to answer these questions it is obvious that we need to collect lots of data. It is also obvious that we need to connect the data so that when we have a organisations we can find all data about it.

But the key is the relationships between the data. The way we connect the data is by categories.

For every dataset we gather about an organisation we look for categories. A company is categorised in different ways in different datasets. In brreg.no the company is categorised by NACE codes (Næringskode). When the company is granted funding from EU or Norwegian Research Council the project is categorised by topics and funding program.
When public tenders are out they are categorised by the type of tender and so on.

All this data is public and we can access, process and import it into our database.

Other data we must collect by scraping websites. We scrape all company websites, looking for keywords.
Companies are member of intrest organisations and networks, here they are also categorised. We scrape membership organisations that list their members and the categories they are in.
Events that companies atend to has a topic and a category. We scrape event websites and look for keywords.

So the following questions are related to how I'm going to connect the data from brreg.no to the Urbalurba database.

## More questions and answers for the shadow-brreg database you can try yourself

Here I will just write the questions and the SQL statements that ChatGPT gives me as answers. I will not write the full explanation from ChatGPT.

>I want to know how many companies that has the same hjemmeside. I want to know the 10 most used hjemmeside's. for each hjemmeside count the number of companies that has the hjemmeside.

```sql
    SELECT hjemmeside, COUNT(hjemmeside) 
    as count_of_orgs FROM brreg_enheter_alle 
    GROUP BY hjemmeside ORDER BY count_of_orgs DESC LIMIT 10;
```

>can you find a company that has a name simmilar to aalesund-chamber?


## Tell ChatGPT what your data looks like

ChatGPT just knows that the fields text and numbers. Not what they mean. So you have to tell ChatGPT what the fields mean.

1. Tell ChatGPT what the table looks like and what it contains

    >Good morning. I don't know sql and I need some help on writing sql statements to access my data. The definition of the table I want to access is:

    ```sql
    CREATE TABLE brreg_enheter_alle (
    organisasjonsnummer character varying(10) NOT NULL,
    navn character varying(255),
    organisasjonsform_kode character varying(10),
    organisasjonsform_beskrivelse character varying(255),
    naringskode_1 character varying(10),
    naringskode_1_beskrivelse character varying(255),
    naringskode_2 character varying(10),
    naringskode_2_beskrivelse character varying(255),
    naringskode_3 character varying(10),
    naringskode_3_beskrivelse character varying(255),
    hjelpeenhetskode character varying(10),
    hjelpeenhetskode_beskrivelse character varying(255),
    antall_ansatte integer,
    hjemmeside character varying(255),
    postadresse_adresse character varying(255),
    postadresse_poststed character varying(255),
    postadresse_postnummer character varying(10),
    postadresse_kommune character varying(255),
    postadresse_kommunenummer character varying(10),
    postadresse_land character varying(40),
    postadresse_landkode character varying(10),
    forretningsadresse_adresse character varying(255),
    forretningsadresse_poststed character varying(255),
    forretningsadresse_postnummer character varying(10),
    forretningsadresse_kommune character varying(40),
    forretningsadresse_kommunenummer character varying(10),
    forretningsadresse_land character varying(40),
    forretningsadresse_landkode character varying(10),
    institusjonell_sektorkode character varying(10),
    institusjonell_sektorkode_beskrivelse character varying(255),
    siste_innsendte_arsregnskap character varying(20),
    registreringsdato_i_enhetsregisteret character varying(20),
    stiftelsesdato character varying(20),
    frivilligregistrertimvaregisteret character varying(100),
    registrert_i_mva_registeret character varying(10),
    registrert_i_frivillighetsregisteret character varying(10),
    registrert_i_foretaksregisteret character varying(10),
    registrert_i_stiftelsesregisteret character varying(10),
    konkurs character varying(10),
    under_avvikling character varying(10),
    under_tvangsavvikling_eller_tvangsopplasning character varying(10),
    overordnet_enhet_i_offentlig_sektor character varying(50),
    malform character varying(10)
    );
    ```

    >The table brreg_enheter_alle is a table of organisations in Norway. The field organisasjonsnummer is the unique id, the field navn is the name of the organisation and the field antall_ansatte is the number of employees in the organisation.
    Can you give me the sql statement that lists the names and number of employees in organisations that has the most employees. Give me the top 10.
    
    *ChatGPT: Sure, here is an SQL statement that will list the names and number of employees of the top 10 organizations with the most employees:*

    ```sql
    SELECT navn, antall_ansatte
    FROM brreg_enheter_alle
    ORDER BY antall_ansatte DESC
    LIMIT 10;
    ```

    *This query will select the `navn` and `antall_ansatte` columns from the `brreg_enheter_alle table`, order the results by the `antall_ansatte` field in descending order and limit the results to the top 10 rows.*

2. How the company name is written

    >The navn field is written in capital letters. When I'm searching, I will use lower case letters. The last text of the name is the type of organisation. I will not provide the type of organisation when searching so you must ignore the last text in the name field. For example when I want to find the organisation named 4service then I want you to find the organisation "4SERVICE AS". Based on this, write the sql to find the organisation named sintef and display the number of employees they have.

    *ChatGPT:*

    ```sql
    SELECT antall_ansatte FROM brreg_enheter_alle WHERE lower(left(navn, length(navn) - position(' ' in reverse(navn)))) = 'sintef';
    ```

    *ChatGPT: Explanation:*
    - The SQL statement selects the antall_ansatte field from the table brreg_enheter_alle
    - The WHERE clause filters the result set by searching for the lowercase version of the name of the organization, obtained by:
        - Using the left() function to extract all characters of the navn field except the last word, which is the type of the organization.
        - Using the length() function to find the length of the navn field, and subtracting the position of the last space in the reversed string, which gives the length of the name without the type.
        - Using the reverse() function to reverse the string and find the position of the last space in the original string.
        - Using the lower() function to convert the name to lowercase letters.
    - Then it compares it to the searched name 'sintef'
    - This will return the number of employees for the organization that matches the name 'sintef'

    >Good, you found it. I want you to remove the last text in the name field and take into consideration that I write the name in lower case every time I search for a name. Based on this can you find the organisation named af gruppen and display the number of employees they have.

    *ChatGPT: Yes, to find the organization named "AF GRUPPEN" and display the number of employees they have, taking into account that the search will be done with the name in lowercase, the following SQL statement can be used:* 

    ```sql
    SELECT
    navn,
    antall_ansatte
    FROM brreg_enheter_alle
    WHERE lower(left(navn, length(navn) - position(' ' in reverse(navn)))) = 'af gruppen'
    ```

    *ChatGPT: Explanation: This statement will lowercase the entire navn field and then use the `left()` and `reverse()` functions to remove the last word (the type of organization) from the name, and then compare that modified name to the search term "af gruppen" to find a match.*
