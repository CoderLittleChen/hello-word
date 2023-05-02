select  *   from   Score   a;

select  *   from   Teacher   a;

select  *   from   Score   a
left join  Teacher  b    on  a.PersonId=b.PersonId;